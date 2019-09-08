// MIT license © 2018-2019, Michiel Sikma <michiel@sikma.org>

const chalk = require('chalk').default
const { sortGen, hardPad, isArray, niceStatus, findLargest, weightStatus, weightPriority, keyMap } = require('./helpers')
const { projectAssets } = require('./assets')

// To account for the distance issues are from the edge (due to the task type icon).
const projectIndent = 2

/**
 * Returns a colorized line indicating the relative number of issues of each priority.
 *
 * @param   {array}  issues  Array of objects of shape { width: {number}, priority: {number} }
 * @param   {string} width   Width in characters of the issue line to generate
 * @param   {string} assets  Object containing special characters for drawing purposes
 * @returns {string}         String containing colorized boxes
 */
const makeIssueLine = (issues, width, assets) => {
  if (!issues || !issues.length) {
    return null
  }

  // Buffer for the issue line.
  const issueLine = []
  // Select the last issue in case we need to fill out remaining characters.
  const issueLast = issues[issues.length - 1]

  // Number of characters we've added to the issue line so far.
  // Due to rounding, we can end up with fewer characters than requested;
  // in that case we use the remainder with the last issue to fill the rest.
  let widthCurrent = 0
  let widthSegment = 0

  // For each issue, add block characters to the buffer.
  for (issue of issues) {
    widthSegment = Math.floor(width * (issue.width / 100))
    widthCurrent += widthSegment
    issueLine.push(chalk.hex(issue.color)(assets.blocks.full.repeat(widthSegment)))
  }

  // If there's some leftover space, fill it out with the last issue.
  width - widthCurrent && issueLine.push(chalk.hex(issueLast.color)(assets.blocks.full.repeat(width - widthCurrent)))
  return issueLine.join('')
}

/**
 * Creates a table displaying project information.
 *
 * @param   {array}  projectGroups Array of project data, i.e. { projects: {array} }
 * @param   {string} screenWidth   Width in characters of the table to generate
 * @param   {string} assets        Object containing special characters for drawing purposes
 * @returns {array}                Array of lines comprising the table
 */
const makeProjectInfo = (projectGroups, screenWidth, assets = projectAssets) => {
  // Buffer for the table lines and for the project items.
  const lines = []
  const projectsRendered = []

  // Width of each project component. Full screen width minus 1 for the spacing,
  // and minus the indent.
  const projectWidth = Math.floor((screenWidth - 1 - projectIndent - projectIndent) / 2)
  // Width of the issue line displaying the project's issue priorities.
  const issueLineWidth = Math.max(Math.floor(projectWidth / 2), 15)

  // A list of all projects inside all project groups.
  const projectsAll = projectGroups.reduce((all, group) => [...all, ...group.projects], [])

  // Determine the maximum string length of each key so we can align the project names next to them.
  const keyWidth = findLargest('key', projectsAll) + 1
  const nameWidth = projectWidth - keyWidth

  // For every project inside every project group, we'll print the key, name, issue line
  // and amount, URL, and a description if it's defined.
  for (const project of projectsAll) {
    const projectLines = []
    const { key, name, description, issueAmount, issuePriorities, issueLink } = project
    const issueLine = makeIssueLine(issuePriorities, issueLineWidth, assets)

    projectLines.push(`${chalk.gray(hardPad(key, keyWidth))}${hardPad(name, nameWidth)}`)
    projectLines.push([
      `Open issues: `,
      issueLine ? issueLine : hardPad('None', issueLineWidth),
      issueLine ? ' ' + hardPad(String(issueAmount), 3) : hardPad('', 4),
      hardPad('', projectWidth - issueLineWidth - 4 - 13)
    ].join(''))
    if (project.description) {
      projectLines.push(`Description: ${hardPad(description, projectWidth - 13)}`)
    }
    projectLines.push(`URL: ${hardPad(issueLink, projectWidth - 5)}`)
    projectsRendered.push(projectLines)
  }

  // Finally, print each project in a table of two columns.
  for (let a = 0; a < projectsRendered.length; a += 2) {
    const projectOne = projectsRendered[a]
    const projectTwo = projectsRendered[a + 1]

    // Determine how many lines to print (after the longest of the two projects.)
    const projectLines = Math.max(projectOne.length, projectTwo ? projectTwo.length : 0)

    let emptyLine = ' '.repeat(projectWidth)
    let indentEmpty = ' '.repeat(projectIndent - 1)
    let indentBullet = hardPad(assets.projectBullet, projectIndent - 1)

    for (let b = 0; b < projectLines; ++b) {
      lines.push([
        ...(projectOne && projectOne[b]
          ? [b === 0 ? indentBullet : indentEmpty, projectOne[b]]
          : [indentEmpty, emptyLine]),
        ...(projectTwo && projectTwo[b]
          ? [b === 0 ? indentBullet : indentEmpty, projectTwo[b]]
          : [indentEmpty, emptyLine])
      ].join(' '))
    }

    lines.push('')
  }

  lines.push('')

  return lines
}

module.exports = {
  makeProjectInfo
}
