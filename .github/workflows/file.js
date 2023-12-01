const { execSync } = require('child_process')
const fs = require('fs');

const executeCommand = (command) =>
  execSync(command, { encoding: 'utf-8' }).trim()

const getCMSChanges = () => {
  const addedLines = executeCommand(
    `git diff ${process.env.GITHUB_EVENT_BEFORE}..${process.env.GITHUB_SHA}`
  )
  if (addedLines) {
  fs.writeFile('issue-template.md', addedLines, (err) => {
  if (err) {
    console.error('Error writing to file:', err);
  } else {
    console.log('File written successfully');
  }
});

  }
}

module.exports = {
    getCMSChanges
}