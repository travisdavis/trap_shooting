require 'spec_helper'

class FakeSchedule
  include Logic::Schedule
end

describe Logic::Schedule do
  it "has one less week than number of teams" do
    fschedule = FakeSchedule.new
    new_schedule = fschedule.create_schedule 8, false
    new_schedule.length.should eq(7)
  end

  it "has the expected results for each round" do
    fschedule = FakeSchedule.new
    new_schedule = fschedule.create_schedule 8, false

    expected_schedule = [
      ["1:8", "2:7", "3:6", "4:5"],
      ["1:7", "8:6", "2:5", "3:4"],
      ["1:6", "7:5", "8:4", "2:3"],
      ["1:5", "6:4", "7:3", "8:2"],
      ["1:4", "5:3", "6:2", "7:8"],
      ["1:3", "4:2", "5:8", "6:7"],
      ["1:2", "3:8", "4:7", "5:6"]]

    for i in 0..6
      for j in 0..3
          new_schedule[i][j].should eq(expected_schedule[i][j])
      end
    end
  end

  it "balances a schedule" do
    fschedule = FakeSchedule.new
    number_of_teams = 12
    new_schedule = fschedule.create_schedule number_of_teams, false

    expected_schedule = [
        ["1:12", "2:11", "3:10", "4:9", "5:8", "6:7"],
        ["1:11", "12:10", "2:9", "3:8", "4:7", "5:6"],
        ["1:10", "11:9", "12:8", "2:7", "3:6", "4:5"],
        ["1:9", "10:8", "11:7", "12:6", "2:5", "3:4"],
        ["1:8", "9:7", "10:6", "11:5", "12:4", "2:3"],
        ["1:7", "8:6", "9:5", "10:4", "11:3", "12:2"],
        ["1:6", "7:5", "8:4", "9:3", "10:2", "11:12"],
        ["1:5", "6:4", "7:3", "8:2", "9:12", "10:11"],
        ["1:4", "5:3", "6:2", "7:12", "8:11", "9:10"],
        ["1:3", "4:2", "5:12", "6:11", "7:10", "8:9"],
        ["1:2", "3:12", "4:11", "5:10", "6:9", "7:8"]]

    new_schedule.length.should eq(number_of_teams-1)

    # we have generated an unbalanced schedule,
    # each round's first match should have team 1
    for i in 0..number_of_teams-2
      new_schedule[i][0].should eq("1:#{number_of_teams-i}")
    end

    balanced_schedule = fschedule.balance new_schedule

    expected_balanced_schedule = [
      ["6:7", "2:11", "3:10", "4:9", "5:8", "1:12"],
      ["1:11", "12:10", "2:9", "3:8", "4:7", "5:6"],
      ["11:9", "1:10", "12:8", "2:7", "3:6", "4:5"],
      ["11:7", "10:8", "1:9", "12:6", "2:5", "3:4"],
      ["11:5", "9:7", "10:6", "1:8", "12:4", "2:3"],
      ["11:3", "8:6", "9:5", "10:4", "1:7", "12:2"],
      ["11:12", "7:5", "8:4", "9:3", "10:2", "1:6"],
      ["9:12", "6:4", "7:3", "8:2", "1:5", "10:11"],
      ["7:12", "5:3", "6:2", "1:4", "8:11", "9:10"],
      ["5:12", "4:2", "1:3", "6:11", "7:10", "8:9"],
      ["3:12", "1:2", "4:11", "5:10", "6:9", "7:8"]]

    balanced_schedule.length.should eq(number_of_teams-1)
	  for i in 0..number_of_teams-2
      for j in 0..number_of_teams/2
          new_schedule[i][j].should eq(expected_balanced_schedule[i][j])
      end
    end
  end

  it "creates a schedule with bye weeks for odd number of teams" do

  end

  it "balances a round" do

  end
end
