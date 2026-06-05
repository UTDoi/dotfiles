#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const readline = require('readline');

// Constants
// Fraction of the context window at which Claude Code triggers auto-compaction.
const COMPACTION_RATIO = 0.8;
// Known context-window sizes (tokens).
const DEFAULT_CONTEXT_LIMIT = 200000;
const LARGE_CONTEXT_LIMIT = 1000000;

/**
 * Decide the context-window size for this session.
 *
 * Priority:
 *   1. CLAUDE_CONTEXT_LIMIT env var (explicit override)
 *   2. Auto-detect: if context ever exceeded the default window, the session
 *      must be running on the 1M-token window (200k would have compacted).
 *   3. Fall back to the default 200k window.
 *
 * @param {number} peakTokens Highest context occupancy observed in the session.
 * @returns {number} Context-window size in tokens.
 */
function getContextLimit(peakTokens) {
  const override = parseInt(process.env.CLAUDE_CONTEXT_LIMIT, 10);
  if (Number.isFinite(override) && override > 0) return override;
  if (peakTokens > DEFAULT_CONTEXT_LIMIT) return LARGE_CONTEXT_LIMIT;
  return DEFAULT_CONTEXT_LIMIT;
}

// Read JSON from stdin
let input = '';
process.stdin.on('data', chunk => input += chunk);
process.stdin.on('end', async () => {
  try {
    const data = JSON.parse(input);

    // Extract values
    const model = data.model?.display_name || 'Unknown';
    const currentDir = path.basename(data.workspace?.current_dir || data.cwd || '.');
    const sessionId = data.session_id;

    // Calculate token usage for current session
    let totalTokens = 0;
    let peakTokens = 0;

    if (sessionId) {
      // Find all transcript files
      const projectsDir = path.join(process.env.HOME, '.claude', 'projects');

      if (fs.existsSync(projectsDir)) {
        // Get all project directories
        const projectDirs = fs.readdirSync(projectsDir)
          .map(dir => path.join(projectsDir, dir))
          .filter(dir => fs.statSync(dir).isDirectory());

        // Search for the current session's transcript file
        for (const projectDir of projectDirs) {
          const transcriptFile = path.join(projectDir, `${sessionId}.jsonl`);

          if (fs.existsSync(transcriptFile)) {
            ({ totalTokens, peakTokens } = await calculateTokensFromTranscript(transcriptFile));
            break;
          }
        }
      }
    }

    // Resolve the compaction threshold from the (possibly auto-detected) window.
    const compactionThreshold = getContextLimit(peakTokens) * COMPACTION_RATIO;

    // Calculate percentage
    const percentage = Math.min(100, Math.round((totalTokens / compactionThreshold) * 100));

    // Format token display
    const tokenDisplay = formatTokenCount(totalTokens);

    // Color coding for percentage
    let percentageColor = '\x1b[32m'; // Green
    if (percentage >= 70) percentageColor = '\x1b[33m'; // Yellow
    if (percentage >= 90) percentageColor = '\x1b[31m'; // Red

    // Build status line
    const statusLine = `[${model}] 📁 ${currentDir} | 🪙 ${tokenDisplay} | ${percentageColor}${percentage}%\x1b[0m`;

    console.log(statusLine);
  } catch (error) {
    // Fallback status line on error
    console.log('[Error] 📁 . | 🪙 0 | 0%');
  }
});

/**
 * Sum the token counts of a single usage entry into a context-occupancy figure.
 *
 * @param {object} usage An assistant message's `usage` object.
 * @returns {number} input + output + cache (creation + read) tokens.
 */
function usageToTokens(usage) {
  return (usage.input_tokens || 0) +
    (usage.output_tokens || 0) +
    (usage.cache_creation_input_tokens || 0) +
    (usage.cache_read_input_tokens || 0);
}

/**
 * Scan a transcript for token usage.
 *
 * @param {string} filePath Path to the session's `.jsonl` transcript.
 * @returns {Promise<{totalTokens: number, peakTokens: number}>}
 *   `totalTokens` is the latest message's context occupancy (current usage);
 *   `peakTokens` is the highest occupancy seen, used to detect a 1M window.
 */
async function calculateTokensFromTranscript(filePath) {
  return new Promise((resolve, reject) => {
    let lastUsage = null;
    let peakTokens = 0;

    const fileStream = fs.createReadStream(filePath);
    const rl = readline.createInterface({
      input: fileStream,
      crlfDelay: Infinity
    });

    rl.on('line', (line) => {
      try {
        const entry = JSON.parse(line);

        // Check if this is an assistant message with usage data
        if (entry.type === 'assistant' && entry.message?.usage) {
          lastUsage = entry.message.usage;
          peakTokens = Math.max(peakTokens, usageToTokens(lastUsage));
        }
      } catch (e) {
        // Skip invalid JSON lines
      }
    });

    rl.on('close', () => {
      const totalTokens = lastUsage ? usageToTokens(lastUsage) : 0;
      resolve({ totalTokens, peakTokens });
    });

    rl.on('error', (err) => {
      reject(err);
    });
  });
}

function formatTokenCount(tokens) {
  if (tokens >= 1000000) {
    return `${(tokens / 1000000).toFixed(1)}M`;
  } else if (tokens >= 1000) {
    return `${(tokens / 1000).toFixed(1)}K`;
  }
  return tokens.toString();
}
