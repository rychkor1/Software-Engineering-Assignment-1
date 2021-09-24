#Project name: Assignment 1 Application Development
#Description: Project to sort students into FYS courses based on their top 6 choices, without overloading classes
#Filename: Roman_Rychkov_assignment1.rb
#File Description: main file for the project, which contains everything needed, other than Input/Output files
#Last Modified on: 9/23/2021

require 'csv' #ruby gem needed to read csv

#Get the program ready to intake input from the user and the input files
puts "Enter the number of FYS courses being offered: "
num_courses = gets.to_i #chomp gets rid of the newline after the gets

puts "Enter the number of students in the incoming class: "
num_students = gets.to_i

f = 1 #using a number to detect a file failure
while f == 1 #switches to 0 if correct file to break from loop
    puts "Enter the course list file name (include .csv at the end): "
    input1 = gets.chomp
    if File.file?(input1)
        course_array = CSV.parse(File.read(input1), headers: true) #properly reads through the csv file and populates course_array
        f = 0 #exits the loop as it found the correct file
        break
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
        f = 0 #exits the loop as it found the correct file
        break
    else
        puts "Wrong file name, try again \n"
    end
end

#Ask the user to provide the names of the output files
puts "Enter the name for output file 1 (include .txt at the end): "
outfile1 = gets.chomp

puts "Enter the name for output file 2 (include .txt at the end): "
outfile2 = gets.chomp

puts "Enter the name for output file 3 (include .txt at the end): "
outfile3 = gets.chomp

#Making a class for courses to fill in new objects with data from the input
class Course
    attr_accessor :course_id, :course_num, :course_title
    def initialize(course_id, course_num, course_title)
        @course_id = course_id.to_s
        @course_num = course_num.to_s
        @course_title = course_title.to_s
        @course_size = 0 #starts at 0 and will go up with every student added
        @students = [] #keeps track of student ids in the course
    end

    def course_size_out #gets course_size
        return @course_size
    end

    def add_to_size #adds to the course_size
        @course_size += 1
    end

    def students_out #gets the string version of the array of student ids
        return (@students).join(", ")
    end

    def add_student(id) #outputs the student id's array in the form of a string
        @students << id.to_s 
    end
    
end

#Making a class for student to fill in new objects with data from the input
class Student
    attr_accessor :student_id, :choice1, :choice2, :choice3, :choice4, :choice5, :choice6
    def initialize(student_id, choice1, choice2, choice3, choice4, choice5, choice6)
        @student_id = student_id.to_s
        @choice1 = choice1.to_s
        @choice2 = choice2.to_s
        @choice3 = choice3.to_s
        @choice4 = choice4.to_s
        @choice5 = choice5.to_s
        @choice6 = choice6.to_s
    end
end

#Populating the course array with course objects
pop_course_array = [] #the populated course array with the course objects
num_courses.times do |index|
    id = course_array[index]["Id"]
    num = course_array[index]["Number"]
    title = course_array[index]["Title"]
    pop_course_array[index] = Course.new(id, num, title)
end

#Populating the student array with student objects
pop_student_array = [] #the populated student array with the student objects
num_students.times do |index|
    id = student_array[index]["Id"]
    first = student_array[index]["First Choice"]
    second = student_array[index]["Second Choice"]
    third = student_array[index]["Third Choice"]
    fourth = student_array[index]["Fourth Choice"]
    fifth = student_array[index]["Fifth Choice"]
    sixth = student_array[index]["Sixth Choice"]
    #choices come up as null if six are not given
    pop_student_array[index] = Student.new(id, first, second, third, fourth, fifth, sixth) 
end

#Algorithm to put students into a class based on their top 6 choices
#The total size of the course goes up with every enrollment, and there is a counter that counts for that as well
#The student's id goes into the course's student id array
#Checks for duplicates through each if/else
enroll_count = 0 #a tracker to count how many total students have been enrolled
for student in pop_student_array
    for course in pop_course_array
        if (student.choice1 == course.course_id) and (course.course_size_out < 18)
            course.add_student(student.student_id)
            course.add_to_size
            enroll_count += 1
        elsif (student.choice2 == course.course_id) and (course.course_size_out < 18) and (student.choice2 != student.choice1)
            course.add_student(student.student_id)
            course.add_to_size
            enroll_count += 1
        elsif (student.choice3 == course.course_id) and (course.course_size_out < 18) and (student.choice3 != student.choice2) and (student.choice3 != student.choice1)
            course.add_student(student.student_id)
            course.add_to_size
            enroll_count += 1
        elsif (student.choice4 == course.course_id) and (course.course_size_out < 18) and (student.choice4 != student.choice3) and (student.choice4 != student.choice2) and (student.choice4 != student.choice1)
            course.add_student(student.student_id)
            course.add_to_size
            enroll_count += 1
        elsif (student.choice5 == course.course_id) and (course.course_size_out < 18) and (student.choice5 != student.choice4) and (student.choice5 != student.choice3) and (student.choice5 != student.choice2) and (student.choice5 != student.choice1)
            course.add_student(student.student_id)
            course.add_to_size
            enroll_count += 1
        elsif (student.choice6 == course.course_id) and (course.course_size_out < 18) and (student.choice6 != student.choice5) and (student.choice6 != student.choice4) and (student.choice6 != student.choice3) and (student.choice6 != student.choice2) and (student.choice6 != student.choice1)
            course.add_student(student.student_id)
            course.add_to_size
            enroll_count += 1
        end
    end
end
not_enroll_count = num_students - enroll_count #a tracker to count total students not enrolled

#Output list of students to output file 1
File.open(outfile1, "w") do |file| #creates a file and writes to it
    file.puts("FYS Course Id, Student Id")
    for course in pop_course_array #course is an arbitrary object in the pop_course_array for loop
        file.puts(course.course_id + " " + course.students_out)
    end
end

#Output details of enrollments to output file 2
more_ten = 0 #a tracker to count how many classes are operational (10 or more students)
less_ten = 0 #a tracker to count how many classes are not operational (less than 10 students)
File.open(outfile2, "w") do |file| #creates a file and writes to it
    for course in pop_course_array #course is an arbitrary object in the pop_course_array for loop
        if course.course_size_out >= 10
            file.puts(course.course_id + " " + course.course_num + " " + course.course_title + " " + course.students_out)
            more_ten += 1
        else
            file.puts(course.course_id + " " + course.course_num + " " + course.course_title + " THIS COURSE HAS FEWER THAN 10 STUDENTS!")
            less_ten += 1
        end
    end
end

#Output a summary of results, and alerts the user about issues during execution to output file 3
File.open(outfile3, "w") do |file| #creates a file and writes to it
    file.puts("The number of students enrolled in a course: " + enroll_count.to_s)
    file.puts("The number of students not enrolled in a course: " + not_enroll_count.to_s)
    file.puts("The number of classes with 10 or more students: " + more_ten.to_s)
    file.puts("The number of classes with less than 10 students: " + less_ten.to_s)
end