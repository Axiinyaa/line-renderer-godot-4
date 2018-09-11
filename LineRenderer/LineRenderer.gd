extends ImmediateGeometry

export var points = [Vector3(0,0,0),Vector3(0,5,0)]
export var startThickness = 0.1
export var endThickness = 0.1
export var cornerSmooth = 5
export var capSmooth = 5
export var drawCaps = true
export var drawCorners = true
export var globalCoords = true
export var scaleTexture = true

var camera

func _ready():
	pass

func _process(delta):
	if points.size() < 2:
		return
	
	camera = get_viewport().get_camera()
	if camera == null:
		return
	
	var progressStep = 1.0 / points.size();
	var progress = 0;
	var thickness = lerp(startThickness, endThickness, progress);
	var nextThickness = lerp(startThickness, endThickness, progress + progressStep);
	
	clear()
	begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for i in range(points.size() - 1):
		var A = points[i]
		var B = points[i+1]
	
		if globalCoords:
			A = to_local(A)
			B = to_local(B)
	
		var AB = B - A;
		var orthogonalABStart = (to_local(camera.get_global_transform().origin) - ((A + B) / 2)).cross(AB).normalized() * thickness;
		var orthogonalABEnd = (to_local(camera.get_global_transform().origin) - ((A + B) / 2)).cross(AB).normalized() * nextThickness;
		
		var AtoABStart = A + orthogonalABStart
		var AfromABStart = A - orthogonalABStart
		var BtoABEnd = B + orthogonalABEnd
		var BfromABEnd = B - orthogonalABEnd
		
		if i == 0:
			if drawCaps:
				corner(A, B, thickness, capSmooth)
		
		if scaleTexture:
			var ABLen = AB.length()
			var ABFloor = floor(ABLen)
			var ABFrac = ABLen - ABFloor
			
			set_uv(Vector2(ABFloor, 0))
			add_vertex(AtoABStart)
			set_uv(Vector2(-ABFrac, 0))
			add_vertex(BtoABEnd)
			set_uv(Vector2(ABFloor, 1))
			add_vertex(AfromABStart)
			set_uv(Vector2(-ABFrac, 0))
			add_vertex(BtoABEnd)
			set_uv(Vector2(-ABFrac, 1))
			add_vertex(BfromABEnd)
			set_uv(Vector2(ABFloor, 1))
			add_vertex(AfromABStart)
		else:
			set_uv(Vector2(1, 0))
			add_vertex(AtoABStart)
			set_uv(Vector2(0, 0))
			add_vertex(BtoABEnd)
			set_uv(Vector2(1, 1))
			add_vertex(AfromABStart)
			set_uv(Vector2(0, 0))
			add_vertex(BtoABEnd)
			set_uv(Vector2(0, 1))
			add_vertex(BfromABEnd)
			set_uv(Vector2(1, 1))
			add_vertex(AfromABStart)
		
		if i == points.size() - 2:
			if drawCaps:
				corner(B, A, nextThickness, capSmooth)
		else:
			if drawCorners:
				corner(B, A, nextThickness, cornerSmooth)
		
		progress += progressStep;
		thickness = lerp(startThickness, endThickness, progress);
		nextThickness = lerp(startThickness, endThickness, progress + progressStep);
	
	end()

func corner(center, pivot, thickness, smoothing):
	var orthogonal = (to_local(camera.get_global_transform().origin) - center).cross(center - pivot).normalized() * thickness;
	var axis = (center - to_local(camera.get_global_transform().origin)).normalized();
	
	var array = []
	for i in range(smoothing + 1):
		array.append(Vector3(0,0,0))
	array[0] = center + orthogonal;
	array[smoothing] = center - orthogonal;
	
	for i in range(1, smoothing):
		array[i] = center + (orthogonal.rotated(axis, lerp(0, PI, float(i) / smoothing)));
	
	for i in range(1, smoothing + 1):
		var currSmooth = (i - 1) / smoothing
		
		set_uv(Vector2(0, currSmooth))
		add_vertex(array[i - 1]);
		set_uv(Vector2(0, currSmooth))
		add_vertex(array[i]);
		set_uv(Vector2(0.5, 0.5))
		add_vertex(center);
		