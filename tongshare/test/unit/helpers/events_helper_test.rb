require 'test_helper'

class EventsHelperTest < ActionView::TestCase
  setup do
    @course_set = CourseClass.parse_xls("test/fixtures/lc.xls")
  end

  def find_classes(course_name)
    events = []
    @course_set.each do |course_class|
      events << class2event(course_class, 1) if (course_class.name == course_name)
    end
    return events
  end
  
  test "全周单时" do
    course_name = "计算机图形学基础"
    events = find_classes(course_name)
    assert events.size == 1
    assert events[0].name == course_name
    assert events[0].begin.localtime == Time.parse("2011-2-23 8:00")
    assert events[0].end.localtime == Time.parse("2011-2-23 9:35")
    assert events[0].location == "六教6A017"
    assert events[0].extra_info == "胡事民；限选；全周；六教6A017"

    rec = GCal4Ruby::Recurrence.new
    rec.from_rrule(events[0].rrule)
    assert rec.count == 16
    assert rec.frequency == GCal4Ruby::Recurrence::WEEKLY_FREQUENCE
    assert rec.interval == 1
    assert rec.day[3]
    for i in 0...7
      assert !rec.day[i] if i != 3
    end
  end

  test "一门课程全周+双周" do
    course_name = "数值分析"
    events = find_classes(course_name)
    assert events.size == 2
    begins = ["2011-2-21 8:00", "2011-3-3 15:20"]
    ends = ["2011-2-21 9:35", "2011-3-3 16:55"]
    extra_infos = ["喻文健；限选；全周；六教6C201", "喻文健；限选；双周；六教6C201"]
    week_days = [1, 4]
    intervals = [1, 2]
    for  i in 0...2 
      assert events[i].name == course_name
      assert events[i].location == "六教6C201"
      assert events[i].extra_info == extra_infos[i]
      assert events[i].begin.localtime == Time.parse(begins[i])
      assert events[i].end.localtime == Time.parse(ends[i])
      rec = GCal4Ruby::Recurrence.new
      rec.from_rrule(events[i].rrule)
      assert rec.frequency == GCal4Ruby::Recurrence::WEEKLY_FREQUENCE
      assert rec.day[week_days[i]]
      for day in 0...7
        assert !rec.day[day] if day != week_days[i]
      end
      assert rec.interval == intervals[i]
    end
  end

  test "前八周单时" do
    course_name = "计算机软件前沿技术"
    events = find_classes(course_name)
    assert events.size == 1
    rec = GCal4Ruby::Recurrence.new
    rec.from_rrule(events[0].rrule)
    assert(rec.count == 8)
    assert(rec.interval == 1)
    assert(rec.frequency == GCal4Ruby::Recurrence::WEEKLY_FREQUENCE)
    assert(events[0].begin.localtime == Time.parse("2011-2-22 15:20"))
  end

  test "后八周单时" do
    course_name = "后八周测试课程"
    events = find_classes(course_name)
    assert events.size == 1
    assert events[0].begin.localtime == Time.parse("2011-2-26 9:50") + (8*7).days
    assert events[0].end.localtime == Time.parse("2011-2-26 11:25") + (8*7).days
    rec = GCal4Ruby::Recurrence.new
    rec.from_rrule(events[0].rrule)
    assert(rec.count == 8)
    assert(rec.interval == 1)
    assert(rec.frequency == GCal4Ruby::Recurrence::WEEKLY_FREQUENCE)
  end

  test "单周单时" do
    course_name = "单周测试课程"
    events = find_classes(course_name)
    assert events.size == 1
    assert events[0].begin.localtime == Time.parse("2011-2-27 13:30")
    assert events[0].end.localtime == Time.parse("2011-2-27 15:05")
    rec = GCal4Ruby::Recurrence.new
    rec.from_rrule(events[0].rrule)
    assert(rec.count == 8)
    assert(rec.interval == 2)
    assert(rec.frequency == GCal4Ruby::Recurrence::WEEKLY_FREQUENCE)
  end

  test "No Week Modifier" do
    course_name = "NO MODIFIER 测试课程"
    events = find_classes(course_name)
    assert events.size == 1
    assert events[0].begin.localtime == Time.parse("2011-2-25 19:20")
    assert events[0].end.localtime == Time.parse("2011-2-25 20:55")
    rec = GCal4Ruby::Recurrence.new
    rec.from_rrule(events[0].rrule)
    assert(rec.count == 16)
    assert(rec.interval == 1)
    assert(rec.frequency == GCal4Ruby::Recurrence::WEEKLY_FREQUENCE)
  end

end
