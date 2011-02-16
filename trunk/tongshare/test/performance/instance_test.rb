require 'test_helper'
require 'rails/performance_test_help'
require 'gcal4ruby'

class InstanceTest < ActionDispatch::PerformanceTest
  USER_NUM = 100
  EVENT_NUM = 10

  def test_generate_instance
#    assert_difference('Event.count', USER_NUM*EVENT_NUM) do
      for user_id in 0...USER_NUM
        for event_i in 0...EVENT_NUM
          begin_time = Time.now + rand(24*60).minutes
          event = Event.new(:name => "TestEvent",
            :begin => begin_time,
            :end => begin_time + rand(180).minutes,
            :creator_id => user_id
          );
          rec = GCal4Ruby::Recurrence.new
          rec.frequency = GCal4Ruby::Recurrence::WEEKLY_FREQUENCE
          rec.set_day(rand(7))
          rec.count = rand(16)+1
          event.rrule = rec.rrule
          event.save
        end
      end
#    end
  end
end
