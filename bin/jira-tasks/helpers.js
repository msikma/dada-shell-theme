// MIT license © 2018-2019, Michiel Sikma <michiel@sikma.org>

/** Helper function used for exiting the script. */
const error = reason => {
  console.log(`jira-list.js: Error: ${reason}`)
  process.exitCode = 1
}

module.exports = {
  error
}
