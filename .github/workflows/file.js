const { execSync } = require('child_process')

const executeCommand = (command) =>
  execSync(command, { encoding: 'utf-8' }).trim()

const getCMSChanges = async () => {
  const addedLines = executeCommand(
    `git diff ${process.env.GITHUB_EVENT_BEFORE}..${process.env.GITHUB_SHA} -- CMS/internationalisation_de_DE.json`
  )
  if (addedLines) {
    try {
        await fs.writeFile('issue-template.md', addedLines)
        console.log('file successed write')
    } catch {
      const errorMessage = 'An Error occured while parsing the json files'
      console.log(`::set-output name=result::${errorMessage}`)
    }
  }
  process.exit(0)
}

module.exports = {
    getCMSChanges
}