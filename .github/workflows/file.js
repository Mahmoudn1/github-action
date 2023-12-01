const { execSync } = require('child_process')
const fs = require('fs');

const executeCommand = (command) =>
  execSync(command, { encoding: 'utf-8' }).trim()

const getCMSChanges = () => {
  const addedLines = executeCommand(
    `git diff ${process.env.GITHUB_EVENT_BEFORE}..${process.env.GITHUB_SHA} -- CMS/internationalisation_de_DE.json`
  )
  if (addedLines) {
    try {
        fs.writeFileSync('issue-template.md', addedLines)
        console.log('file successed write')
    } catch(e) {
      console.log(`${e}`)
    }
  }
  process.exit(0)
}

module.exports = {
    getCMSChanges
}