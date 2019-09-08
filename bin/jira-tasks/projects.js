// MIT license © 2018-2019, Michiel Sikma <michiel@sikma.org>

const chalk = require('chalk').default
const { sortGen, hardPad, isArray, niceStatus, findLargest, weightStatus, weightPriority, keyMap } = require('./helpers')
const { projectAssets } = require('./assets')


const makeIssueLine = (issues, length, assets) => {
  if (!issues || !issues.length) {
    return null
  }
  const line = []
  const lastIssue = issues[issues.length - 1]
  let width = 0
  for (issue of issues) {
    const issueWidth = Math.floor(length * (issue.width / 100))
    width += issueWidth
    line.push(chalk.hex(issue.color)(assets.blocks.full.repeat(issueWidth)))
  }
  const remaining = length - width
  line.push(chalk.hex(lastIssue.color)(assets.blocks.full.repeat(remaining)))
  return line.join('')
}
/*

LD Calypso Discord Bot
Open issues:
Description:

*/

/** Creates a table displaying project information. */
const makeProjectInfo = (rawProjectData, screenWidth, assets = projectAssets) => {
  const lines = []
  lines.push('')
  const issueWidth = 15
  for (projectGroup of rawProjectData) {
    for (project of projectGroup.projects) {
      console.log(project)
      const issueLine = makeIssueLine(project.issueOverview, issueWidth, assets)
      lines.push(`${chalk.gray(hardPad(project.key, 5))}${hardPad(project.name, 40)}`)
      lines.push(`Open issues: ${issueLine ? issueLine : hardPad('None', issueWidth)}`)
      if (project.description) {
        lines.push(`Description: ${project.description}`)
      }
      lines.push(`URL: ${project.issueLink}`)
      lines.push('')
    }
  }
  return lines
}

module.exports = {
  makeProjectInfo
}
