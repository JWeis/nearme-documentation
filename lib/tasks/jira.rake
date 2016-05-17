namespace :jira do
  desc "Populate new foreign keys and flags"
  task :release_sprint, [:sprint_number] => [:environment] do |t, args|
    @jira_helper = JiraHelper.new
    puts @jira_helper.commit_parser.to_s

    @client = JIRA::Client.new({username: 'jira-api', password: 'N#arM3123adam', context_path: '',site: 'https://near-me.atlassian.net', rest_base_path: "/rest/api/2", auth_type: :basic, read_timeout: 120 })

    issues = @client.Issue.jql("project = \"Near Me\" AND sprint = #{args[:sprint_number]} AND status != Closed")

    tickets_assigned_to_sprint = issues.map { |i| [i.key, i.summary].join(' ') }
    puts "All tickets assigned to sprint #{args[:sprint_number]} - total count #{tickets_assigned_to_sprint.count}"
    puts "*******************"
    puts ""
    puts tickets_assigned_to_sprint.join("\n")

    issues_not_included_in_sprint = @jira_helper.to_jira_number(@jira_helper.jira_commits) - @jira_helper.to_jira_number(tickets_assigned_to_sprint)
    puts ""
    puts "Cards assigned to WRONG sprint"
    puts "*******************"
    @cards_to_be_added_to_sprint = []
    issues_not_included_in_sprint.each do |number|
      puts "Is this issue part of the sprint: #{@jira_helper.full_names([number], @jira_helper.jira_commits)[0]} [y]/[n]/[o]"
      user_input = STDIN.gets.strip
      while(!%w(y n).include?(user_input)) do
        if user_input == 'o'
          `launchy https://near-me.atlassian.net/browse/#{number}`
        else
          puts "\tinvalid input"
        end
        user_input = STDIN.gets.strip
      end
      case user_input
      when "y"
        @cards_to_be_added_to_sprint << number
        puts "\tadding to sprint"
      when "n"
        puts "\tskipping"
      end
    end

    issues_without_code = @jira_helper.to_jira_number(tickets_assigned_to_sprint) - @jira_helper.to_jira_number(@jira_helper.jira_commits)
    puts ""
    puts "Cards that have not relevant code"
    puts "*******************"
    issues_without_code.each do |number|
      puts "Is this issue part of the sprint: #{@jira_helper.full_names([number], tickets_assigned_to_sprint)[0]} [y]/[n]/[o]"
      user_input = STDIN.gets.strip
      while(!%w(y n).include?(user_input)) do
        if user_input == 'o'
          `launchy https://near-me.atlassian.net/browse/#{number}`
        else
          puts "\tinvalid input"
        end
        user_input = STDIN.gets.strip
      end
      case user_input
      when "y"
        @cards_to_be_added_to_sprint << number
        puts "\tadding to sprint"
      when "n"
        puts "\tskipping"
      end
    end

    cards_in_commits = @jira_helper.to_jira_number(@jira_helper.jira_commits) & @jira_helper.to_jira_number(tickets_assigned_to_sprint)

    next_tag = @jira_helper.next_tag(1)
    (@cards_to_be_added_to_sprint + cards_in_commits).each do |card_in_sprint|
      @client.Issue.find(card_in_sprint).save({ fields: { fixVersions: [{ name: next_tag }] } })
      @client.Issue.find(card_in_sprint).save({ fields: { customfield_10007: args[:sprint_number].to_i }})
    end

    puts ""
    puts "FINAL LIST OF CARDS RELEASED: "
    puts "*******************"
    puts ""
    puts @jira_helper.full_names(cards_in_commits, @jira_helper.jira_commits).join("\n")
    puts @jira_helper.full_names(@cards_to_be_added_to_sprint, @jira_helper.jira_commits + tickets_assigned_to_sprint).join("\n")
    puts @jira_helper.non_jira_commits.compact.join("\n")
  end

  task :release_hotfix do
    @jira_helper = JiraHelper.new
  end
end

class JiraHelper
  extend Forwardable
  attr_accessor :commit_parser, :client

  class GitCommitParser
    attr_reader :base_revision, :new_revision

    def initialize(base_revision, new_revision)
      @base_revision = base_revision
      @new_revision = new_revision
    end

    def commits_between_revisions
      @commits ||= `git log #{base_revision}..#{new_revision} --no-merges`.split("\n").select { |c| c.include?("    ") }.map(&:strip)
    end

    def jira_commits
      @jira_commits ||= commits_between_revisions.select { |c| c =~ /^NM-\d{4}/ }
    end

    def non_jira_commits
      commits_between_revisions - jira_commits
    end

    def to_s
      puts "Commits between #{base_revision} .. #{new_revision}"
    end

  end

  def initialize(git_commit_parser = nil)
    @commit_parser = git_commit_parser || JiraHelper::GitCommitParser.new((ENV['BASED_TAG'].presence || `git describe`.split('-')[0]),  (ENV['HEAD_TAG'].presence || 'HEAD'))
  end

  def next_tag(number_position)
    arr = last_tag.split('.')
    arr[number_position] = arr[number_position].to_i + 1
    if number_position == 1
      arr[2] = 0
    end
    @next_tag = arr.join('.')
  end

  def last_tag
    `git describe`.split('-')[0]
  end

  def commits_between_revisions
    @commit_parser.commits_between_revisions
  end

  def jira_commits
    @commit_parser.jira_commits
  end

  def non_jira_commits
    @commit_parser.non_jira_commits
  end

  def to_jira_number(array)
    array.map { |a| a.split(' ')[0] }
  end

  def full_names(numbers, array)
    numbers.map { |n| array.find { |a| a.include?(n) } }
  end

end