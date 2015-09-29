

--[[
--written for Minecraft 1.7.10 with ComputerCraft 1.73

--TODO:
--known performance issues: comprehension of back and forward raises syntax error, integrate or + and keywords in code.
--pattern for manual location
--better define function
--no error consistency: even if parameters wrong or not given, the program should not stop
--true false return consistency
--times consistency
--general testing

name				implemented		consistent		compact
* overwrite
* manual_location
* define
* forward			yes				yes				no
* back				yes				yes				no
* up				yes				yes				no
* down				yes				yes				no
* turnLeft
* turnRight

* set				no				no				no
add
turn
face
* fuelNeeded
* traverse

--]]

pos = {}
_G.SOUTH = 0
_G.WEST = 1
_G.NORTH = 2
_G.EAST = 3

function overwrite(keepDefaults)
	if keepDefaults then
		_G.old_forward = turtle.forward
		_G.old_back = turtle.back
		_G.old_up = turtle.up
		_G.old_down = turtle.down
		_G.old_turnLeft = turtle.turnLeft
		_G.old_turnRight = turtle.turnRight
	end
	_G.turtle.forward = forward
	_G.turtle.back = back
	_G.turtle.up = up
	_G.turtle.down = down
	_G.turtle.turnLeft = turnLeft
	_G.turtle.turnRight = turnRight
end

local function manual_location()
	print("Could not determine position. Enter it manually: ")
	pos.x, pos.y, pos.z, pos.facing = string.gmatch(read(), "%")--TODO
end

function define()
	--if automatic detection is successful, this function always takes up a bit more than 4 seconds.
	local pos1, pos2 = {}, {}
	pos1.x, pos1.y, pos1.z = gps.locate()
	if pos.x == nil then--the location could not be determined
		pos = manual_location()
	else--first location search worked
		local pos2 = {}
		if not turtle.forward() then--the turtle could not be moved for location difference
			pos = manual_location()
		else--the turtle has been moved
			pos2.x, pos2.y, pos2.z = gps.locate()
			if pos2.x == nil then
				pos = manual_location()
			else--calculate facing
				if pos1.x == pos2.x then
					if pos1.z < pos2.z then
						pos.facing = SOUTH
					else
						pos.facing = NORTH
					end
				else--z difference must be same
					if pos1.x < pos2.x then
						pos.facing = EAST
					else
						pos.facing = WEST
					end
				end
				pos.x, pos.y, pos.z = pos2.x, pos2.y, pos2.z
			end
			back()
		end
	end
	return true
end

function forward(times)
	if times == nil then
		times = 1
	elseif times < 0 then
		return back(math.abs(times))
	end
	for step=1,times do
		if turtle.forward() then
			--pos.x, pos.z = pos.x + {0, -1, 0, 1}[pos.facing+1], pos.z + {1, 0, -1, 0}[pos.facing+1]
			--will always work
			if pos.facing == SOUTH then
				pos.z = pos.z + 1
			elseif pos.facing == WEST then
				pos.x = pos.x - 1
			elseif pos.facing == NORTH then
				pos.z = pos.z - 1
			elseif pos.facing == EAST then
				pos.x = pos.x + 1
			end
		else
			return false, step-1
		end
	end
	return true
end

function back(times)
	if times == nil then
		times = 1
	elseif times < 0 then
		return forward(math.abs(times))
	end
	for step = 1, times do
		if turtle.back() then
			--pos.x, pos.z = pos.x - {0, -1, 0, 1}[pos.facing+1], pos.z - {1, 0, -1, 0}[pos.facing+1]
			--will always work
			if pos.facing == SOUTH then
				pos.z = pos.z - 1
			elseif pos.facing == WEST then
				pos.x = pos.x + 1
			elseif pos.facing == NORTH then
				pos.z = pos.z + 1
			elseif pos.facing == EAST then
				pos.x = pos.x - 1
			end
		else
			return false, step-1
		end
	end
	return true
end

function up(times)
	if times == nil then
		times = 1
	elseif times < 0 then
		return down(math.abs(times))
	end
	for step = 1, times do
		if turtle.up() then
			pos.y = pos.y + 1
		else
			return false, step-1
		end
	end
	return true
end

function down(times)
	if times == nil then
		times = 1
	elseif times < 0 then
		return up(math.abs(times))
	end
	for step = 1, times do
		if turtle.down() then
			pos.y = pos.y - 1
		else
			return false, step-1
		end
	end
	return true
end

function turnLeft(times, forceFull)
	times = 1 or times
	if turtle.turnLeft() then
		pos.facing = pos.facing - 1
		if pos.facing < 0 then
			pos.facing = 3
		end
		return true
	else
		return false
	end
end

function turnRight(times, forceFull)
	times = 1 or times
	for 
	if turtle.turnRight() then
		pos.facing = (pos.facing + 1) %4
		return true
	else
		return false
	end
end

--[[
look
turn
face
]]

function set(x, y, z facing, force, avoid)
	x = x or pos.x
	y = y or pos.y
	z = z or pos.z
	facing = facing or pos.facing
	if force==nil then
		force = false
	end

	if 
end

function add(x, y, z, facing, force, avoid)
	x = x or 0
	y = y or 0
	z = z or 0
	facing = facing or 0
	force = force or false
	avoid = avoid or {}
	set(pos.x + x, pos.y + y, pos.z + z, pos.facing + facing, force, avoid)
end

function turn(offset, forceFull)
	offset = offset or 0
	if forceFull and offset ~= 0 then
		if offset > 0 then
			--turnLeft
		else
	else
		face((pos.facing + offset)%4)
	end
end

function face(direction)
	if direction and direction ~= pos.facing then
		if (direction-1)%4 == pos.facing then
			turnLeft()
		elseif (direction+1)%4 == pos.facing then
			turnRight()
		else
			turnRight(2)
		end
	end
end

function fuelNeeded(pos1, pos2)
	if pos2 then
		return math.abs(pos1.x-pos2.x)+math.abs(pos1.y-pos2.y)+math.abs(pos1.z-pos2.z)
	else
		return math.abs(pos.x-pos1.x)+math.abs(pos.y-pos1.y)+math.abs(pos.z-pos1.z)
	end
end

function traverse(startPoint, endPoint, callback)
	set(startPoint.x, startPoint.y, startPoint.z)
	for xAxis=startPoint.x
	--do something for every block in a specific type of geometric body
	--Q, S
end
