require 'thucourse'

$KCODE = 'u'

filename = "test/fixtures/lc.xls"

table = xls2table(filename)
course_set = Course.parse_table(table)
pp course_set

