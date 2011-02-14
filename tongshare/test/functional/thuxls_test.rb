require 'thuxls'

$KCODE = 'u'

filename = "tmp/lc.xls"

table = xls2table(filename)
course_set = Course.parse_table(table)
pp course_set

