class Student
  attr_accessor :id, :name, :grade
  
  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all(query="")
    DB[:conn].execute("SELECT * FROM students " + query).map {|student| new_from_db(student)}
  end

  def self.find_by_name(name)
    all("WHERE name = '#{name}'")[0]
  end

  def self.all_students_in_grade_9
    all("WHERE grade = 9")
  end

  def self.students_below_12th_grade
    all("WHERE grade < 12")
  end
  
  def self.first_X_students_in_grade_10(num)
    all("WHERE grade = 10 LIMIT #{num}")
  end

  def self.first_student_in_grade_10
    first_X_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_X(num)
    all("WHERE grade = #{num}")
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
