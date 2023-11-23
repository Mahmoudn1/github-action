function compareFiles(baseContent, currentContent) {
    const baseLines = baseContent.split('\n');
  const currentLines = currentContent.split('\n');

  const changes = [];

  // Compare each line
  for (let i = 0; i < Math.max(baseLines.length, currentLines.length); i++) {
    const baseLine = baseLines[i] || '';
    const currentLine = currentLines[i] || '';

    if (baseLine !== currentLine) {
      changes.push({
        line: i + 1, // Line number (1-indexed)
        base: baseLine,
        current: currentLine,
      });
    }
  }

  return changes;
}

module.exports = compareFiles;