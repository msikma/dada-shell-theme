#!/usr/bin/env node

// Displays some basic information about the Node project in this directory.
// If there is no package.json in the directory, nothing will be output.

const fs = require('fs')
if (!fs.existsSync(`${process.cwd()}/package.json`)) process.exit()
const { name, description, version, homepage, bin, scripts } = require(`${process.cwd()}/package.json`)
const leftSize = 15
const rightSize = process.stdout.columns - leftSize - 1

const green = '[32m'
const normal = '[30m(B[m'
const red = '[31m'
const yellow = '[33m'
const blue = '[34m'
const purple = '[35m'
const link = '[4m[34m'

const limitSize = (str, size) => {
	if (str.length <= size) return str
	return str.slice(0, size - 1) + '…'
}

console.log('')
console.log(`${red}${name}${normal} ${purple}(${version})${normal} ${homepage ? `${blue}<${link}${homepage}${normal}${blue}>${normal}` : ''}`)
if (description) {
	console.log(`${green}${description}${normal}`)
}
if (Object.keys(bin || {}).length > 0 || Object.keys(scripts || {}).length > 0) {
	console.log('')
}

Object.keys(bin || {}).sort().forEach(b => {
	const left = limitSize(b, leftSize)
	const right = limitSize(bin[b], rightSize)
	console.log([
		yellow,
		left,
		normal,
		' '.repeat(leftSize - left.length),
		' ',
		right
	]
	.join(''))
})

Object.keys(scripts || {}).sort().forEach(s => {
	const left = limitSize(s, leftSize)
	const right = limitSize(scripts[s], rightSize)
	console.log([
		blue,
		left,
		normal,
		' '.repeat(leftSize - left.length),
		' ',
		right
	]
	.join(''))
})

console.log('')