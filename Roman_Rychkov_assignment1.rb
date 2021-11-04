#Project name: Assignment 1 Application Development
#Description: Project to sort students into FYS courses based on their top 6 choices, without overloading classes
#Filename: Roman_Rychkov_assignment1.rb
#File Description: main file for the project, which contains everything needed, other than Input/Output files
#Last Modified on: 10/24/2021

require 'csv' #ruby gem needed to read csv

#Making a class for courses to fill in new objects with data from the input
class Course
    @@max_size = 18 #max size of the courses
    attr_accessor :course_id, :course_num, :course_title, :students
    def initialize(course_id, course_num, course_title)
        @course_id = course_id
        @course_num = course_num
        @course_title = course_title
        @students = [] #keeps track of student ids in the course and puts in array
    end

    def add_student(student) #adds the student to the course if the max size of the class is not reached
        if size() < @@max_size
            @students << student.student_id
            student.enroll(@course_id) #enroll the student to the course
            return true
        end
        return false
    end  

    def size() #the size of the class based on how many students are in the class
        return @students.length()
    end
end

#Making a class for student to fill in new objects with data from the input
class Student
    attr_accessor :student_id, :choices, :course_id
    def initialize(student_id)
        @student_id = student_id 
        @choices = [] #choice array for student's choice ids
        @course_id = nil #student's course id is nil until chosen
    end

    def add_choice(course_id) #put course id of the choice into the choices array
        @choices << course_id
    end

    def enroll(course_id) #enroll the student by attaching the student's course id to the true course id
        @course_id = course_id
    end
end

#Get the program ready to intake input from the user and the input files
puts "Enter the number of FYS courses being offered: "
num_courses = gets.to_i 

puts "Enter the number of students in the incoming class: "
num_students = gets.to_i

f = 1 #using a number to detect a file failure
while f == 1 #switches to 0 if correct file to break from loop
    puts "Enter the course list file name (include .csv at the end): "
    input1 = gets.chomp
    if File.file?(input1)
        course_array = CSV.parse(File.read(input1), headers: true) #properly reads through the csv file and populates course_array
        course_map = {} #the map holding keys of the course id
        for course in course_array #going through parsed array
            if course_map.size() < num_courses #to not parse through beyond the user's input value
                course_id = course[0].to_i
                course_num = course[1].to_s
                course_title = course[2].to_s
                course_map[course_id] = Course.new(course_id, course_num, course_title) #create course object and map
            else
                break #break out of parsing
            end
        end
        f = 0 #exits the loop as it found the correct file
    else
        puts "Wrong file name, try again \n"
    end
end

f = 1 #using a number to detect a file failure
while f == 1 #switches to 0 if correct file to break from loop
    puts "Enter the student selections file name (include .csv at the end): "
    input2 = gets.chomp
    if File.file?(input2)
        student_array = CSV.parse(File.read(input2), headers: true) #properly reads through the csv file and populates student_array
        student_map = {} #the map holding the keys of student id
        for student in student_array #going through parsed array
            if student_map.size() >= num_students #to not parse through beyond the user's input value
                break
            end
            student_id = student[0].to_i 
            if !student_map.key?(student_id) #making the keys for the map to store student's id
                student_map[student_id] = Student.new(student_id) #create student object and map
            end
            course_id = student[1].to_i
            if course_map.key?(course_id) #making the keys for the map to store student's course id
                student_map[student_id].add_choice(course_id) #add choice to student's choices if the key matches a student's choice
            else #used for error checking if student has no correct choice
                #puts "student_id=", student_id, " has incorrect choice course_id=", course_id
            end  
        end
        f = 0 #exits the loop as it found the correct file
    else
        puts "Wrong file name, try again \n"
    end
end

#Algorithm to put students into a class based on their top 6 choices
#If their choices are not chosen or are full, they are put into a random left over class.
#Runs through student and course maps to compare the course ids and store into student's course id if matched
student_map.each do |student_id, student| #iterate through the student map
    for choice in student.choices #iterate through the choices
        if course_map.key?(choice) #if the choice matches the course
            course = course_map[choice]
            if course.add_student(student) #if the student is successfully added to the course
                break #if successful, then break
            end
        end
    end
    if student.course_id == nil #after iterating through choices, if the student still has no course
        course_map.each do |course_id, course| #iterate through course map
            if course.add_student(student) #if student is successfully added to the course
                break #if successful, then break
            end
        end #used for error checking
        if student.course_id == nil
            #puts student
        end
    end
end
                
#Ask the user to provide the names of the output files
puts "Enter the name for output file 1 (include .txt at the end): "
outfile1 = gets.chomp

puts "Enter the name for output file 2 (include .txt at the end): "
outfile2 = gets.chomp

puts "Enter the name for output file 3 (include .txt at the end): "
outfile3 = gets.chomp

#Output list of students to output file 1
File.open(outfile1, "w") do |file| #creates a file and writes to it
    file.puts("FYS Course Id, Student Id") #header
    course_map.each do |course_id, course| #iterate through course map
        for student_id in course.students #iterate through student ids
            file.print(course.course_id, ", ", student_id, "\n") #print out student ids along with their proper courses
        end
    end
end

#Output details of enrollments to output file 2
more_ten = 0 #a tracker to count how many classes are operational (10 or more students)
less_ten = 0 #a tracker to count how many classes are not operational (less than 10 students)
File.open(outfile2, "w") do |file| #creates a file and writes to it
    course_map.each do |course_id, course| #iterate through course map
        if course.size() >= 10 #if the class is runnable
            file.print(course.course_id, ", ", course.course_num, ", ", course.course_title, ": \n") #print out course info
            for student_id in course.students
                file.puts(student_id) #print out the student ids
            end
            file.puts #an extra space
            more_ten += 1 #counter moves up
        else
            file.print(course.course_id, ", ", course.course_num, ", ", course.course_title, ": THIS COURSE HAS FEWER THAN 10 STUDENTS! \n") #print out course info
            for student in course.students
                file.puts(student_id) #prints out the student ids
            end
            file.puts #an extra space
            less_ten += 1 #counter moves up
        end
    end
end

n = 0 #a counter for each student enrolled
student_map.each do |student_id, student| #iterate through student map
    if student.course_id != nil
        n += 1 #increase number of students enrolled
    end
end

#Output a summary of results, and alerts the user about issues during execution to output file 3
not_enrolled = student_map.size() - n #gives the number of students not enrolled
File.open(outfile3, "w") do |file| #creates a file and writes to it
    file.puts("The number of students enrolled in a course: ", n)
    file.puts("The number of students not enrolled in a course: ", not_enrolled)
    file.puts("The number of classes with 10 or more students: ", more_ten)
    file.puts("The number of classes with less than 10 students: ", less_ten)
end
