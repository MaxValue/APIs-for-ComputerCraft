
term.clear()
os.loadAPI("human_stdio")
os.loadAPI("location")
location.define()

startpoint = {}
endpoint = {}
io.write("Define the area of the acre to be farmed.\nEnter Startpoint: ")
startpoint.x, startpoint.y, startpoint.z = read("*n","*n","*n")
io.write("Enter Endpoint: ")
endpoint.x, endpoint.y, endpoint.z = read("*n","*n","*n")

startpoint = human_stdio.raw_input("Define the area of the acre to be farmed.\nEnter Startpoint: ", 3)
endpoint = human_stdio.raw_input("Enter Endpoint: ", 3)
print("Starting...")
mainloop = true

--CONSTRUCTION SITE
CropKnowledge = {}
CropKnowledge["minecraft:wheat"] = {maxAge = 7}
CropKnowledge["minecraft:potatoes"] = {maxAge = 7}

while mainloop do
	location.traverse(startpoint, endpoint, farm)
end

--CONSTRUCTION SITE
function farm()
	thereIsABlock, blockData = turtle.inspectDown()
	if thereIsABlock then
		if blockData[2] == knowledge.blocks[CROP] then
			turtle.digDown()
			turtle.select(SEEDS)
			turtle.placeDown()
		end
	else
		turtle.select(SEEDS)
		turtle.placeDown()
	end
end
