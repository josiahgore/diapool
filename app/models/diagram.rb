require 'RMagick'

class Diagram
  attr_accessor(:balls)

  def initialize()
    @balls = {}
    @startx = 82.5
    @starty = 82.5
    @ball = 15
    @diamond = 177
  end

  def addBall(number, x, y)
    @balls[number] = { x: x, y: y }
  end

  def generate()
    tableImage = Magick::ImageList.new("app/assets/images/table.png")
    drawGrid(tableImage)
    @balls.each { |k,v| drawBall(tableImage, k, v[:x], v[:y]) }
    @generatedImage = "app/assets/images/table" + ('a'..'z').to_a().shuffle()[0..7].join() + ".png"
    tableImage.change_geometry!('512') { |rows, cols, img| img.resize!(rows, cols) }
    tableImage.write("png:" + @generatedImage)
    return true
  end

  def drawGrid(tableImage)
    (1..7).each do |x|
      draw = Magick::Draw.new
      draw.line(@startx + x * @diamond, @starty, @startx + x * @diamond, @starty + 4 * @diamond)
      draw.draw(tableImage)
    end
    (1..3).each do |y|
      draw = Magick::Draw.new
      draw.stroke_dasharray(50, 50)
      draw.line(@startx, @starty + y * @diamond, @startx + 8 * @diamond, @starty + y * @diamond)
      draw.draw(tableImage)
    end
  end

  def drawBall(tableImage, number, x, y)
    x = Float(x) * @diamond
    y = Float(y) * @diamond
    x = x - @ball if x >= 8 * @diamond
    x = x + @ball if x == 0
    y = y - @ball if y >= 4 * @diamond
    y = y + @ball if y == 0
    shape = createShapeForBall(number, @startx + x, @starty + y)
    shape.draw(tableImage)
  end

  def createShapeForBall(number, x, y)
    number = String(number)
    shape = Magick::Draw.new
    shape.stroke_opacity(1)
    shape.stroke_width(3)

    if number == 'cue'
      shape.stroke('white')
      shape.fill('white')
      shape.ellipse(x, y, 15, 15, 0, 360)

    elsif number == 'target'
      shape.stroke('DarkSlateGray3')
      shape.fill_opacity(0)
      offset = 50
      shape.polygon(x - offset, y - offset, x + offset, y - offset, x + offset, y + offset, x - offset, y + offset)

    elsif isInteger?(number)
      color = getColorForNumber(number)

      shape.stroke(color)
      if Integer(number) <= 8
        shape.fill(color)
      else
        shape.fill_opacity(0)
      end
      shape.ellipse(x, y, 15, 15, 0, 360)
    end

    return shape
  end

  def isInteger?(number)
    Integer(number)
  rescue ArgumentError
    false
  else
    true
  end

  def getColorForNumber(number)
    case number
      when '1', '9'
        color = 'yellow'
      when '2', '10'
        color = 'blue'
      when '3', '11'
        color = 'tomato'
      when '4', '12'
        color = 'purple'
      when '5', '13'
        color = 'orange'
      when '6', '14'
        color = 'green'
      when '7', '15'
        color = 'maroon'
      when '8'
        color = 'black'
    end
    return color
  end
  def getImage()
    return @generatedImage
  end

  def cleanup()
    File.delete(@generatedImage)
  end

end
