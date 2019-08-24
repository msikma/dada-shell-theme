// MIT license © 2018-2019, Michiel Sikma <michiel@sikma.org>

/** Helper function used for exiting the script. */
const error = reason => {
  console.log(`jira-list.js: Error: ${reason}`)
  process.exitCode = 1
}

/** Returns Jira info in JSON format using the ms-jira-cli program. */
const getJiraData = (path) => {
  if (existsSync(path)) {
    return JSON.parse(readFileSync(path))
  }
  try {
    const stdout = execSync('ms-jira-cli --action data --output json')
    const data = JSON.parse(stdout.toString('utf8'))
    return data
  }
  catch (err) {
    error('Could not retrieve Jira info.\n' + err.stdout)
  }
}

module.exports = {
  error,
  getJiraData
}
