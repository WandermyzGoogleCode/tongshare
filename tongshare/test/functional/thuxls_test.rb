require 'thuxls'

$KCODE = 'u'

if ($*.size > 0)
  table = xls2table($*[0])
  course_set = Course.parse_table(table)
  pp course_set
else
  puts "You must provide a filename."
end

