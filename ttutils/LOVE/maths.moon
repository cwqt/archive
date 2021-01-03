return {
	dist: (x1,y1, x2,y2) -> return (((x2)-(x1))^2+((y2)-(y1))^2)^0.5

	clamp: (low, n, high) -> return math.min(math.max(n, low), high)
}
