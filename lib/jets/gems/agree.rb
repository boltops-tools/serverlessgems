module Jets::Gems
  class Agree
    def initialize
      @agree_file = "#{ENV['HOME']}/.jets/agree"
    end

    # Only prompts if hasnt prompted before and saved a ~/.jets/agree file
    def prompt
      return if bypass_prompt
      return if File.exist?(@agree_file) && File.mtime(@agree_file) > Time.parse("2021-04-12")

      puts <<~EOL
        Jets uses pre-built binary gems from the serverlessgems.com service to
        provide a user-friendly developer experience. The Serverless Gems Service
        rate limits free gem download requests daily. You can upgrade to a paid plan
        for unlimited gem download requests. Open Source projects may also qualify
        for a free unlimited plan. More info:

          https://www.serverlessgems.com/rate-limits

        If you do not want to use Serverless Gems, you can disable the Serverless
        Gems service and provide your own custom Lambda Layer. More info:

          https://rubyonjets.com/docs/serverlessgems/
          https://rubyonjets.com/docs/extras/custom-lambda-layers/

        Also, reporting gems to Serverless Gems allows it to build new gems typically
        within a few minutes. So if you run into missing gems, you can try deploying
        again after a few minutes. Non-reported gems may take several days or longer.
        Serverless Gems only collects the info it needs to run the service.
        More info: https://www.serverlessgems.com/privacy
        This message will only appear once on this machine.

        You can also automatically skip this message by setting:
        JETS_AGREE=yes or JETS_AGREE=no

        Is it okay to send your gem data to Serverless Gems? (Y/n)?
      EOL

      answer = $stdin.gets.strip
      value = answer =~ /y/i ? 'yes' : 'no'

      write_file(value)
    end

    # Allow user to bypass prompt with JETS_AGREE=1 JETS_AGREE=yes etc
    # Useful for CI/CD pipelines.
    def bypass_prompt
      agree = ENV['JETS_AGREE']
      return false unless agree

      if %w[1 yes true].include?(agree.downcase)
        write_file('yes')
      else
        write_file('no')
      end

      true
    end

    def yes?
      File.exist?(@agree_file) && IO.read(@agree_file).strip == 'yes'
    end

    def no?
      File.exist?(@agree_file) && IO.read(@agree_file).strip == 'no'
    end

    def yes!
      write_file("yes")
    end

    def no!
      write_file("no")
    end

    def write_file(content)
      FileUtils.mkdir_p(File.dirname(@agree_file))
      IO.write(@agree_file, content)
    end
  end
end
