#!/usr/bin/env node

const path = require('path');

// Fraction of the context window at which Claude Code triggers auto-compaction.
// The real threshold is a runtime setting (autoCompactThreshold) not exposed to
// the status line, so this assumes the default. The displayed percentage is
// "how close to auto-compaction", not "how much of the window is used".
const COMPACTION_RATIO = 0.8;

// Read JSON from stdin
let input = '';
process.stdin.on('data', chunk => input += chunk);
process.stdin.on('end', () => {
  try {
    const data = JSON.parse(input);

    const model = data.model?.display_name || 'Unknown';
    const currentDir = path.basename(data.workspace?.current_dir || data.cwd || '.');

    // Claude Code passes context occupancy directly; current_usage/used_percentage
    // are null before the first API call and right after /compact.
    const cw = data.context_window || {};
    const u = cw.current_usage;
    const totalTokens = u
      ? (u.input_tokens || 0) + (u.output_tokens || 0) +
        (u.cache_creation_input_tokens || 0) + (u.cache_read_input_tokens || 0)
      : 0;
    const usedPct = cw.used_percentage ?? 0;

    // Rescale window usage to distance-to-compaction.
    const percentage = Math.min(100, Math.round(usedPct / COMPACTION_RATIO));

    const tokenDisplay = formatTokenCount(totalTokens);

    let percentageColor = '\x1b[32m'; // Green
    if (percentage >= 70) percentageColor = '\x1b[33m'; // Yellow
    if (percentage >= 90) percentageColor = '\x1b[31m'; // Red

    console.log(`[${model}] 📁 ${currentDir} | 🪙 ${tokenDisplay} | ${percentageColor}${percentage}%\x1b[0m`);
  } catch (error) {
    // Fallback status line on error
    console.log('[Error] 📁 . | 🪙 0 | 0%');
  }
});

function formatTokenCount(tokens) {
  if (tokens >= 1000000) {
    return `${(tokens / 1000000).toFixed(1)}M`;
  } else if (tokens >= 1000) {
    return `${(tokens / 1000).toFixed(1)}K`;
  }
  return tokens.toString();
}
