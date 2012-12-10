class Section < ActiveRecord::Base
  attr_accessible :instruction, :instruction_breakdown,  :instruction_responses, :instruction_enroll_count
  attr_accessible :course, :course_breakdown, :course_responses, :course_enroll_count
  attr_accessible :learned, :learned_breakdown, :learned_responses, :learned_enroll_count
  attr_accessible :challenge, :challenge_breakdown, :challenge_responses, :challenge_enroll_count
  attr_accessible :stimulation, :stimulation_breakdown, :stimulation_responses, :stimulation_enroll_count
  attr_accessible :time_breakdown, :feedback, :school_breakdown, :class_breakdown, :reasons_breakdown, :interest_breakdown

  belongs_to :professor
  belongs_to :quarter
  belongs_to :subject
  belongs_to :title
  belongs_to :year

  def course_num
    title.course_num
  end

  def course_num_2
    title.course_num_2
  end

  def subject_abbrev
    subject.abbrev
  end

  def self.find_all name
    subject_abbrev = name.split(' ')[0]
    course_num = name.split(' ')[1]
    subject = Subject.find_by_abbrev(subject_abbrev)
    title = nil

    if subject.nil?
      return nil
    else
      sections = []
      if not name.match(/\S* \d\d\d-\d/).nil?
        subject.sections.each { |s| sections << s if s.course_num_2 == course_num }
      elsif not name.match(/\S* \d\d\d/).nil?
        subject.sections.each { |s| sections << s if s.course_num == course_num }
      end
      return sections
    end
  end

  def self.average type, section_name
    if section_name.nil?
      sections = Section.all
    else
      sections = find_all section_name
    end

    sum = 0
    enroll_count = 0
    sections.each do |s|
      sum = sum + s.send(type) * s.send("#{type}_enroll_count")
      enroll_count = enroll_count + s.send("#{type}_enroll_count")
    end
    return sum / enroll_count
  end

  def self.find_by_id id
    section = Section.where(:id => id)
    return section
  end

  def self.feedback name
    sections = find_all name
    feedback = []
    sections.each do |s|
      feedback << s.feedback.split('/')
    end
    return feedback
  end

  def self.find_by_query_params params
    sections = []
    if params[:p].nil?
      professors = []
    else
      if params[:p].include?(',')
        professors = params[:p].split(',')
      else
        professors = [params[:p]]
      end
      professors.collect! {|p_id| Professor.find(p_id)}
      professors.each do |p|
        sections.concat(p.sections)
      end
    end
    return sections
  end
end
