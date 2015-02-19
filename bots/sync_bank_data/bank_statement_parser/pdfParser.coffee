PythonShell  = require 'python-shell'
nodePath     = require 'path'
fs           = require 'fs'

parseDate = (dateString, startDate) ->
  parts = dateString.split('.')
  if parts.length > 2
    year = parts[2]
    if year.length == 2
      year = "20" + year
  else
    year =
      if startDate?
        startDate.getFullYear()
      else
        new Date().getFullYear()
  return new Date(year, (parts[1] - 1), parts[0])


isTotalTypeLine = (line, pattern) ->
  mapping = pattern.mapping
  return (line[mapping.execDate] == "" or !pattern.execDateRegExp.test(line[mapping.execDate])) and
         line[mapping.date]? and
         pattern.dateRegExp.test(line[mapping.date])
         line[mapping.title] != "" and
         (line[mapping.debitAmount] != "" or line[mapping.creditAmount] != "")

isEntryLine = (line, pattern) ->
  mapping = pattern.mapping
  return line[mapping.execDate] != "" and
         line[mapping.date]? and
         pattern.dateRegExp.test(line[mapping.date])
         line[mapping.title] != "" and
         (line[mapping.debitAmount] != "" or line[mapping.creditAmount] != "")

isComplementaryLine = (line, pattern) ->
  mapping = pattern.mapping
  return (!line[mapping.execDate]? or line[mapping.execDate] == "") and
         line[mapping.date] == "" and
         line[mapping.title] != "" and
         line[mapping.debitAmount] == "" and
         line[mapping.creditAmount] == ""

LCL =
  page:
    fromWord: "DATE"
    toWord:   "TOTAUX"
  entryPattern:
    dateRegExp: /\d\d\.\d\d/
    execDateRegExp: /\d\d\.\d\d\.\d\d/
    mapping:
      'date':         1
      'title':        2
      'execDate':     3
      'debitAmount':  4
      'creditAmount': 5
  statementPattern:
    regexp: /du (\d\d\.\d\d.\d{4}) au (\d\d\.\d\d.\d{4}) - N° (\d+)/
    mapping:
      'startDate':       1
      'endDate':         2
      'statementNumber': 3

basePath = __dirname

pdfParser = (path, callback) ->
  if fs.statSync(path).isDirectory()
    for file in fs.readdirSync(path)
      pdfParser(
        nodePath.join path, file
        callback
      )
    return
  scriptPath = nodePath.join basePath, 'python'
  console.log scriptPath
  full = new PythonShell(
    'bank_statement_parser.py'
    {
      scriptPath: scriptPath
      args: [
        path
      ]
    }
  )
  #console.log full
  pages = []
  full.on 'message', (page) =>
    pages.push page
    console.log "page"

    match = page.match LCL.statementPattern.regexp
    if match
      startDate       = parseDate(match[LCL.statementPattern.mapping.startDate])
      endDate         = parseDate(match[LCL.statementPattern.mapping.endDate])
      statementNumber = parseInt match[LCL.statementPattern.mapping.statementNumber]
      console.log startDate, endDate, match[0]

    tables = new PythonShell(
      'bank_statement_parser.py'
      {
        scriptPath: scriptPath
        args: [
          "--fromword"
          "DATE"
          "--toword"
          "TOTAUX"
          path
        ]
      }
    )

    tables.on 'message', (message) =>
      #entry = parseLine(message, LCL)
      entries = []
      lines = message.split('\\n')
      for id, line of lines
        line = line.replace(/^\s+\d+ \| \|/, '|').replace(/\s{2,}/g, '').split('|')
        date = line[LCL.entryPattern.mapping.date]
        if isTotalTypeLine(line, LCL.entryPattern)
          #skip
        else
          if isEntryLine(line, LCL.entryPattern)
            entry = {}
            entries.push(entry)
            for label, id of LCL.entryPattern.mapping
              if line[id] != ""
                value = line[id]
                if  label.indexOf('amount') >= 0 or
                    label.indexOf('Amount') >= 0
                  value = value.replace(/\s/g, '').replace(/,/g, '.')
                else if label.indexOf('date') >= 0 or
                        label.indexOf('Date') >= 0
                  value = parseDate(value, startDate).getTime()
                entry[label] = value
          else if isComplementaryLine(line, LCL.entryPattern) and
                  entries.length > 0
            entry = entries[-1..][0]
            if line[LCL.entryPattern.mapping.title] != ""
              entry.title += '\n' + line[LCL.entryPattern.mapping.title]
          else
            #console.log line

      callback(entries)

    tables.on 'error', (err) ->
      console.error 'error in tables', err

    tables.end (err) ->
      if err
        console.error err

  full.on 'error', (err) ->
    console.error 'error in full', err
  full.end (err) ->
    if err
      console.error err

module.exports = pdfParser