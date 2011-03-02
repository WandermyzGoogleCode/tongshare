#!/usr/bin/ruby

$KCODE = 'u'

require 'pp'
require 'rubygems'
require 'escape'

#TODO put this config outside source file
module AuthConstant
  MAXTRY = 10
  GETXLS_PATH = "/var/www/hack/"
  SEMESTER = "2010-2011-2"
end

class ThuAuth
  # Make sure that all auth procedure should be single-thread. Otherwise, the file
  # might be changed during auth. For example, use Thread.exclusive
  def self.auth_with_xls(username, password)
    Dir.chdir(AuthConstant::GETXLS_PATH)
    (0...AuthConstant::MAXTRY).each do
      command = Escape.shell_command(["./getxls.sh", username, password, AuthConstant::SEMESTER])
      `#{command}`
      puts "m1"
      size = File.size?("output.xls")
      puts "m2"
      if (size && size > 0)
        puts "successful #{username}"
        return true
      end
    end
      puts "failed #{username}"
    return false
  end

  def self.parse_name
    Dir.chdir(AuthConstant::GETXLS_PATH)

    if File.readable?("Login.out")
      f = File.new("Login.out", "r")
      content = f.readlines.join("")
      m = content.match %r!当前用户：\W*</span></td><td valign="middle" align="center"><span class="uportal-navi-user">(.*)</span></td><td><img height(.|\n)*(最近成功登录记录)!
      return m[1] if m
    end
    return nil
  end

  # returns [authenticated, name] (boolean, String)
  # xls is stored in AuthConstant::GETXLS_PATH + "output.xls"
  # Make sure that all auth procedure should be single-thread. Otherwise, the file
  # might be changed during auth. For example, use Thread.exclusive
  def self.do_auth(username, password)
    result1 = false # auth_with_xls(username, password)
    pp "result1", result1
    Dir.chdir(AuthConstant::GETXLS_PATH)
    File.delete("Login.out") if File.exist? "Login.out"
    command = Escape.shell_command(["./getname.sh", username, password])
    `#{command}`
    name = parse_name
    result2 = (!name.nil?)
    pp "result2", result2
    return result1 || result2, name
  end
end

if __FILE__ == $0
  if $*.size != 2
    puts <<HELP
    Usage: #{$0} <user_id> <password> <semester>
    e.g.
    #{$0} 2007001002 TestPassword
HELP
    exit
  end

  pp ThuAuth.do_auth($*[0], $*[1])
end
