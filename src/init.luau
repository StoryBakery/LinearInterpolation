--!native
local LinearInterpolation = {}

export type Interpolation<T> = (a: T, b: T, alpha: number) -> T

function LinearInterpolation.byType<T>(a: T, b: T, alpha: number): T
	local t = typeof(a)
	local func = LinearInterpolation[t]
	if func then
		return func(a, b, alpha)
	else
		error(`No interpolation function found for type "{t}".`)
	end
end

function LinearInterpolation.FindFunctionFromValueType<T>(value: T): Interpolation<T>?
	return LinearInterpolation[typeof(value)]
end

function LinearInterpolation.GetFunctionFromValueType<T>(value: T): Interpolation<T>
	return LinearInterpolation[typeof(value)] or error(`No interpolation function found for type "{typeof(value)}".`)
end

LinearInterpolation.number = math.lerp

local function lerpWithMethod(a, b, alpha)
	return a:Lerp(b, alpha)
end

LinearInterpolation.Vector3 = lerpWithMethod :: Interpolation<Vector3>
LinearInterpolation.Vector2 = lerpWithMethod :: Interpolation<Vector2>
LinearInterpolation.CFrame = lerpWithMethod :: Interpolation<CFrame>
LinearInterpolation.Color3 = lerpWithMethod :: Interpolation<Color3>
LinearInterpolation.UDim2 = lerpWithMethod :: Interpolation<UDim2>

LinearInterpolation.UDim = function(a: UDim, b: UDim, alpha: number): UDim
	return UDim.new(math.lerp(a.Scale, b.Scale, alpha), math.lerp(a.Offset, b.Offset, alpha))
end

return table.freeze(LinearInterpolation)
