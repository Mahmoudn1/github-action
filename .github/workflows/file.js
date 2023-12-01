const { execSync } = require('child_process')

const executeCommand = (command) =>
  execSync(command, { encoding: 'utf-8' }).trim()

const getCMSChanges = async () => {
  const addedLines = executeCommand(
    `git diff ${process.env.GITHUB_EVENT_BEFORE}..${process.env.GITHUB_SHA}`
  )
  if (addedLines) {
    try {
        await fs.writeFile('issue-template.md', addedLines)
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