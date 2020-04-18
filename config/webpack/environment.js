const { environment } = require('@rails/webpacker')
const typescript =  require('./loaders/typescript')

const eslint = require('./loaders/eslint')
environment.loaders.append('eslint', eslint)

environment.loaders.prepend('typescript', typescript)
module.exports = environment
