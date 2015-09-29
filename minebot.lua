
term.clear()
os.loadAPI("location")
location.define()
startpoint = {}
endpoint = {}
io.write("Define the area to be mined.\nEnter Startpoint: ")
startpoint.x, startpoint.y, startpoint.z = read("*n","*n","*n")
io.write("Enter Endpoint: ")
endpoint.x, endpoint.y, endpoint.z = read("*n","*n","*n")
print("Moving to Startpoint...")
location.set(startpoint)
