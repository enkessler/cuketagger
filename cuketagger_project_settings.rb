ENV['CUKETAGGER_REPORT_FOLDER'] ||= "#{__dir__}/reports"
ENV['CUKETAGGER_RSPEC_REPORT_NAME'] ||= 'rspec_report'
ENV['CUKETAGGER_RSPEC_REPORT_HTML_FILE'] ||= "#{ENV['CUKETAGGER_RSPEC_REPORT_NAME']}.html"
ENV['CUKETAGGER_CUCUMBER_REPORT_NAME'] ||= 'cucumber_report'
ENV['CUKETAGGER_CUCUMBER_REPORT_HTML_FILE'] ||= "#{ENV['CUKETAGGER_CUCUMBER_REPORT_NAME']}.html"
