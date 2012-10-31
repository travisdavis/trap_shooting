# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all

user = User.create(
  :name => "Travis Davis",
  :email => "travis.davis@gmail.com"
)

user.services.create(
  :provider => "facebook",
  :uid => "1357525168",
  :uname => "Travis Davis",
  :uemail => "travis.davis@gmail.com"
)

season_1 = user.seasons.create(
  :name => 'Fall of 2011',
  :start_date => Date.new(2011,10,8,18),
  :houses => 4,
  :time_slots => 2,
  :handicap_calculation => 0.7,
  :description => 'Santa Ynez Valley Sportsman Association Fall 2011 Trap Shooting League'
)

# add sixteen teams
for team_number in (1..16) do
  new_team = season_1.teams.create(
    :number => team_number,
    :name => "Team #{team_number}",
    :description => "Team #{team_number} description goes here"
  )

  # add five shooters
  for shooter_position in (1..5) do
    new_team.shooters.create(
      :position => shooter_position,
      :name => "Shooter #{shooter_position}",
      :handicap_yardage => 27,
      :description => "Shooter #{shooter_position} description goes here"
    )
  end
end

puts "Create the schedule for the first season"
schedule = season_1.create_Type1_schedule

# save the schedule in the DB
for round in 0..(schedule.count)
  if schedule[round].nil?
    next
  end

  for match in 0..(schedule[round].count-1)
    teams = schedule[round][match].split(":")
    season_1.matches.create(
      :week_number => round+1,
      :slot => match,
      :first_team => Integer(teams[0]),
      :second_team => Integer(teams[1])
    )
  end
end

puts "Schedule created."

####### Add a second season #######
season_2 = user.seasons.create(
  :name => 'Spring of 2012',
  :start_date => Date.new(2012,02,22,18),
  :houses => 2,
  :time_slots => 2,
  :handicap_calculation => 0.7,
  :description => 'Santa Ynez Valley Sportsman Association Spring 2012 Trap Shooting League'
)

# add four teams
for team_number in (1..4) do
  new_team_1 = season_2.teams.create(
    :number => team_number,
    :name => "Team #{team_number}",
    :description => "Team #{team_number} description goes here"
  )

  # randomize the handicap yardage
  handicap_yardage = [20,27,22,25]

  # add five shooters
  for shooter_position in (1..5) do
    new_team_1.shooters.create(
      :position => shooter_position,
      :name => "Shooter #{shooter_position}",
      :handicap_yardage => handicap_yardage[team_number - 1],
      :description => "Shooter #{shooter_position} description goes here"
    )
  end
end

puts "Create the schedule for the second season"
schedule2 = season_2.create_schedule season_2.teams.count, false

# save the schedule in the DB
for round in 0..(schedule2.count)
  if schedule2[round].nil?
    next
  end

  for match in 0..(schedule2[round].count-1)
    teams = schedule2[round][match].split(":")
    new_match = season_2.matches.create(
      :week_number => round+1,
      :slot => match,
      :first_team => Integer(teams[0]),
      :second_team => Integer(teams[1])
    )
    puts "matches.count[#{season_2.matches.count}]"
  end
end

puts "Schedule created."

puts "add some results"
# add some results

matches = season_2.matches.order(:id)

for match in matches
  puts "Add results for match #{match.id}"
  # there are two teams per match
  match_team_numbers = [match.first_team, match.second_team]

  # for each team in the match
  for team_number in match_team_numbers
    match_team = Team.find_by_number(team_number)
    puts "Add Team #{match_team.number} shooters resluts"

    # add resluts for each shooter
    for shooter in match_team.shooters
      result = match.results.create(
        :match_id => match.id,
        :shooter_id => shooter.id,
        :sixteen_yards => 20,
        :handicap => 21
      )
      puts "match.results.count[#{match.results.count}]"
    end
  end
end

season_3 = user.seasons.create(
  :name => 'Fall of 2012',
  :start_date => Date.new(2011,10,10,18),
  :houses => 4,
  :time_slots => 2,
  :handicap_calculation => 0.7,
  :description => 'Fall 2012 Trap Shooting League'
)

# add sixteen teams
for team_number in (1..16) do
  new_team = season_3.teams.create(
    :number => team_number,
    :name => "Team #{team_number}",
    :description => "Team #{team_number} description goes here"
  )

  # add five shooters
  for shooter_position in (1..5) do
    new_team.shooters.create(
      :position => shooter_position,
      :name => "Shooter #{shooter_position}",
      :handicap_yardage => 27,
      :description => "Shooter #{shooter_position} description goes here"
    )
  end
end
