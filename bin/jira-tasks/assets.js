// MIT license © 2018-2019, Michiel Sikma <michiel@sikma.org>

const chalk = require('chalk').default

const projectAssets = {
  blocks: {
    full: '█',
    shadeDark: '▓',
    shadeMedium: '▒',
    shadeLight: '░'
  },

  colors: [
    // From lowest priority (0) to highest (4).
    chalk.green,
    chalk.greenBright,
    chalk.yellow,
    chalk.hex('#ff5a00'), // orange
    chalk.red
  ],

  projectBullet: '•'
}

const tableAssets = {
  // For strings that have to be shortened.
  ellipsis: '…',

  // List of icons and arrows to use for the task and priority cols.
  icons: {
    arrUp: '\u2191',
    arrMiddle: '•',
    arrDown: '\u2193',

    ticketTask: '✓',
    ticketBug: '✗',
    ticketStory: '*',
    ticketEpic: 'e',
    ticketSubtask: '└'
  },

  // Colors used for different priorities.
  colors: {
    highest: chalk.red,
    high: chalk.hex('#ff5a00'), // orange
    medium: chalk.yellow,
    low: chalk.greenBright,
    lowest: chalk.green,

    borders: chalk.white,
    otherInfo: chalk.gray
  },

  // Box drawing characters for displaying tables.
  box: {
    topLeft: '╭',
    top: '─',
    topRight: '╮',
    left: '│',
    right: '│',
    bottomLeft: '╰',
    bottom: '─',
    bottomRight: '╯',

    vertical: '│',
    horizontalDown: '┬',
    horizontalUp: '┴'
  }
}

module.exports = {
  projectAssets,
  tableAssets
}
