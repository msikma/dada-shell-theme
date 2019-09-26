// MIT license © 2018-2019, Michiel Sikma <michiel@sikma.org>

const chalk = require('chalk').default
const { sortGen, hardPad, isArray, findLargest, weightStatus, weightPriority, keyMap } = require('./helpers')
const { contribsAssets } = require('./assets')

// To account for the distance issues are from the edge (due to the task type icon).
const projectIndent = 2
// The space used to print the day name.
const dayNameIndent = 4
// The space used to print the month name.
const monthNameIndent = 4

/** Returns the color in which we should print a contrib square. */
const getContribColor = (amount, assets) => {
  if (amount <= 0) return assets.colors[5]
  if (amount > 0 && amount <= 6) return assets.colors[4]
  if (amount > 6 && amount <= 13) return assets.colors[3]
  if (amount > 13 && amount <= 20) return assets.colors[2]
  if (amount > 20 && amount <= 25) return assets.colors[1]
  if (amount > 25) return assets.colors[0]
}

/** Returns the number of the given date's day of the week (1-7). */
const getDayNumber = date => {
  const dateObj = new Date(date)
  return dateObj.getDay()
}

/** Returns the day of the week from a number. */
const getDay = dayNumber => ({
  1: 'Mon', 2: 'Tue',
  3: 'Wed', 4: 'Thu',
  5: 'Fri', 6: 'Sat',
  7: 'Sun'
})[dayNumber] || dayNumber

/** Returns the number of the given date's month. */
const getMonthNumber = date => {
  const dateObj = new Date(date)
  return dateObj.getMonth()
}

/** Returns the month for a month number. */
const getMonth = monthNumber => ({
  0: 'Jan', 1: 'Feb', 2: 'Mar',
  3: 'Apr', 4: 'May', 5: 'Jun',
  6: 'Jul', 7: 'Aug', 8: 'Sep',
  9: 'Oct', 10: 'Nov', 11: 'Dec'
})[monthNumber] || monthNumber

/** Counts how many days we've sequentially made commits. */
const getStreak = contribsData => {
  const dates = Object.values(contribsData.dates).reverse()
  let streak = 0
  for (const date of dates) {
    if (date.count === 0) break
    streak += 1
  }
  return streak
}

/**
 * Creates a table displaying project information.
 *
 * @param   {array}  contribsData Array of contrib data, i.e. { dates: {array} }
 * @param   {string} screenWidth  Width in characters of the table to generate
 * @param   {string} assets       Object containing special characters for drawing purposes
 * @returns {array}               Array of lines comprising the table
 */
const makeContribsInfo = (contribsData, screenWidth, assets = contribsAssets) => {
  // We'll generate each week as an array of colored blocks, and then render them in columns.
  const allWeeks = []

  let week = []
  let a = 0
  const z = 7

  for (const [date, item] of Object.entries(contribsData.dates)) {
    if (a >= z) {
      a = 0
      allWeeks.push(week)
      week = []
    }
    const color = getContribColor(item.count, assets)
    week.push([color(assets.blocks.full), date])
    a += 1
  }
  if (week.length > 0) {
    allWeeks.push(week)
  }

  // Count how many days we've sequentially posted to Github.
  const streak = getStreak(contribsData)

  // Buffer for the actual lines printed to the screen.
  const lines = []

  // Slice the weeks we'll display to an amount that will fit on the screen.
  const space = (allWeeks.length * 2) + projectIndent + projectIndent + dayNameIndent
  const weeks = space < screenWidth ? allWeeks : allWeeks.slice(-Math.floor((screenWidth - projectIndent - projectIndent - dayNameIndent) / 2))

  lines.push(hardPad(assets.headlineBullet, projectIndent) + contribsData.info.headline + ` - current commit streak: ${streak} days`)
  lines.push(' '.repeat(projectIndent) + `@${contribsData.user.username} - ${contribsData.user.organization} (${contribsData.user.website})`)
  lines.push('')

  // First, render the top header.
  let lastMonth
  const header = []
  header.push(' '.repeat(projectIndent + dayNameIndent))
  for (let b = 0; b < weeks.length; ++b) {
    const week = weeks[b]
    if (!week) break
    const date = week[0][1]
    const monthNumber = getMonthNumber(date)
    const month = getMonth(monthNumber)
    if (month !== lastMonth) {
      header.push(`${hardPad(month, monthNameIndent - (b >= weeks.length - 2 ? 1 : 0))}`)
      lastMonth = month
    }
    header.push(' ')
  }
  lines.push(header.join(''))

  // Then render the blocks.
  for (a = 0; a < z; ++a) {
    const line = []
    for (let b = 0; b < weeks.length; ++b) {
      const week = weeks[b]
      if (!week[a]) break
      const block = []
      const dayNumber = getDayNumber(week[a][1])
      const day = getDay(dayNumber)
      if (!week[a]) continue
      if (b === 0) {
        block.push(' '.repeat(projectIndent))
        if (dayNumber === 1 || dayNumber === 3 || dayNumber === 5) {
          block.push(hardPad(day, dayNameIndent))
        }
        else {
          block.push(' '.repeat(dayNameIndent))
        }
      }

      block.push(`${week[a][0]} `)
      line.push(block.join(''))
    }
    lines.push(line.join(''))
  }

  return lines
}

module.exports = {
  makeContribsInfo
}
