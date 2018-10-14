#!/usr/bin/env node

// Displays some basic information about the Node project in this directory.
// Example output:
//
//    msikma-lib-projects (1.0.0) <https://github.com/msikma/msikma-lib-projects>
//    Monorepo container for msikma-lib-projects, containing a number of client libraries
//    Last commit: 2018-10-14 22:29:35 +0200 (63 minutes ago)
//
//    yarn │ run compile            │ bin buyee-cli          │ doc readme.md
//         │     dev                │     marktplaats-cli    │     license.md
//         │                        │     mlib               │     todo.md
//
// To set up a trigger so that this script gets run whenever entering a project folder,
// on Fish Shell it needs to be run on a change of the 'dirprev' variable.
// Example: <https://gist.github.com/msikma/addce5c8cd218c863e1e4b297aa6ae7b>

const { exec } = require('child_process')
const { existsSync, readdirSync } = require('fs')

// Terminal color codes used in output.
const green = '[32m'
const normal = '[30m(B[m'
const red = '[31m'
const yellow = '[33m'
const cyan = '[36m'
const blue = '[34m'
const purple = '[35m'
const link = '[4m[34m'
// Vertical line: U+2502 BOX DRAWINGS LIGHT VERTICAL
const line = '\u2502'

// Calls an external program and returns the result.
const callExternal = cmd => new Promise((resolve, reject) => {
  exec(cmd, (err, stdout = '', stderr = '') => {
    if (err) return reject(stdout.trim(), stderr.trim(), err)
    else resolve(stdout.trim(), stderr.trim())
  })
})

// Limits the size of a string to a certain value and adds an ellipsis if shortened.
const limitSize = (str, size) => {
	if (str.length <= size) return str
	return str.slice(0, size - 1) + '…'
}

// Pads the size of a string to a certain value with spaces.
const padSize = (str, size) => {
  return str + ' '.repeat(Math.max(size - str.length, 0))
}

// Files we'll load to determine output.
const cwd = process.cwd()
const pkg = `${cwd}/package.json`
const yarn = `${cwd}/yarn.lock`
const lerna = `${cwd}/lerna.json`

// We'll print three columns of this size: 'run', 'bin', 'doc'.
const leftSize = 18

if (!existsSync(pkg)) {
  // If there is no package.json in the directory, just exit.
  process.exit()
}

// Does this project prefer Yarn or npm?
const isYarn = existsSync(yarn)

// Retrieve project info. If a version isn't set in the package.json we'll try for lerna.json.
const { name, description, version, homepage, bin, scripts } = require(pkg)
const lernaVersion = existsSync(lerna) ? require(lerna).version : ''

// List all Markdown files in the directory. Always sort readme.md on top.
const isReadme = fn => fn.toLowerCase() === 'readme.md'
const dirCont = readdirSync(cwd)
const mdFiles = (dirCont.filter((f) => /.*\.(md)/gi.test(f))
  .sort((a, b) => isReadme(a) ? -1 : isReadme(b) ? 1 : a > b) || [])

// Prints the project info. First the title and description, then Git info,
// and finally three lists containing all npm scripts, bins and docs.
const printInfo = (git) => {
  // Bin can be a string; in that case duplicate the filename for the key.
  const binObj = typeof bin === 'string' ? { [bin.split('/').slice(-1)[0]]: bin } : bin
  // Items to print in the columns. Default these items to an empty object.
  const binItems = binObj ? binObj : {}
  const scriptItems = scripts ? scripts : {}
  
  // Git information string. Uses the items we loaded in 'gitCmds'.
  const gitLine = git ? `Last commit: ${git.date} (${git.dateRel})` : ''
  
  // Print the title, version and description.
  console.log('')
  console.log([
    `${red}${name}${normal} `,
    `${version || lernaVersion ? `${purple}(${version || lernaVersion})${normal} ` : ``}`,
    `${homepage ? `${blue}<${link}${homepage}${normal}${blue}>${normal}` : ''}`
  ].join(''))
  if (description) {
    console.log(`${green}${description}${normal}`)
  }
  if (gitLine) {
    console.log(`${yellow}${gitLine}${normal}`)
  }
  
  // If we're displaying any columns, add a linebreak before them.
  if (Object.keys(binItems).length > 0 ||
      Object.keys(scriptItems).length > 0 ||
      Object.keys(mdFiles).length > 0) {
    console.log('')
  }

  // Find out which of the three is the longest - we'll use that many iterations.
  const binKeys = Object.keys(binItems).sort()
  const scriptKeys = Object.keys(scriptItems).sort()
  const docKeys = Object.keys(mdFiles) // already sorted earlier.
  const iterate = Math.max(binKeys.length, scriptKeys.length, docKeys.length)
  
  // Draw the columns. We're drawing it one row at a time,
  // printing all three columns with every iteration.
  for (let n = 0; n < iterate; ++n) {
    const scriptName = scriptKeys[n]
      ? limitSize(scriptKeys[n], leftSize)
      : ' '.repeat(leftSize)
    const binName = binKeys[n]
      ? limitSize(binKeys[n], leftSize)
      : ' '.repeat(leftSize)
    const mdName = mdFiles[n]
      ? limitSize(mdFiles[n], leftSize)
      : ' '.repeat(leftSize)
    const mgrLabel = n === 0
      ? isYarn
        ? 'yarn'
        : ' npm'
      : isYarn
        ? '    '
        : '    '
    const scriptLabel = n === 0
      ? 'run'
      : '   '
    const binLabel = n === 0
      ? 'bin'
      : '   '
    const mdLabel = n === 0
      ? 'doc'
      : '   '
    console.log([
      yellow,
      mgrLabel,
      ' ',
      line,
      ' ',
      scriptLabel,
      ' ',
      blue,
      padSize(!scriptName.trim() && n === 0 ? '-' : scriptName, leftSize),
      ' ',
      yellow,
      line,
      ' ',
      binLabel,
      ' ',
      purple,
      padSize(!binName.trim() && n === 0 ? '-' : binName, leftSize),
      ' ',
      yellow,
      line,
      ' ',
      mdLabel,
      ' ',
      red,
      padSize(!mdName.trim() && n === 0 ? '-' : mdName, leftSize),
      normal
    ].join(''))
  }

  console.log('')
}

// We'll display this information from the Git repo.
const gitCmds = {
  // We don't particularly need these.
  // branch: 'git describe --all | sed s@heads/@@',
  // hash: 'git rev-parse --short head',
  // count: 'git rev-list head --count',
  date: 'git log -n 1 --date=iso8601 --pretty=format:%cd',
  dateRel: 'git log -n 1 --date=relative --pretty=format:%cd'
}

// Load Git info (if this is a repo) and then construct the output.
Promise.all(Object.keys(gitCmds).map(type => callExternal(gitCmds[type])))
  .then(gitInfo => {
    // Reintegrate the results with the command object.
    const gitObj = Object.keys(gitCmds).reduce((acc, item, idx) => ({ ...acc, [item]: gitInfo[idx] }), {})
    printInfo(gitObj)
  })
  .catch(_ => printInfo())
