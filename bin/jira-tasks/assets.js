// MIT license © 2018-2019, Michiel Sikma <michiel@sikma.org>

const chalk = require('chalk').default

const contribsAssets = {
  blocks: {
    // U+2586: Lower Three Quarters Block
    full: '▆'
  },

  colors: [
    chalk.red,
    chalk.hex('#ff5a00'),
    chalk.yellow,
    chalk.greenBright,
    chalk.green,
    chalk.dim.gray
  ],

  headlineBullet: '•'
}

const projectAssets = {
  blocks: {
    full: '█',
    shadeDark: '▓',
    shadeMedium: '▒',
    shadeLight: '░'
  },

  colors: [
    // From highest priority (0) to lowest (4).
    chalk.red,
    chalk.hex('#ff5a00'), // orange
    chalk.yellow,
    chalk.greenBright,
    chalk.green
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
  contribsAssets,
  tableAssets
}
