#!/usr/bin/env python3

from dataclasses import dataclass

import tqdm
# import matplotlib.pyplot as plt

@dataclass
class Point:
    x: int
    y: int


@dataclass
class LineSegment:
    p1: Point
    p2: Point

    def is_horizontal(self) -> bool:
        return self.p1.y == self.p2.y
    
    def is_vertical(self) -> bool:
        return self.p1.x == self.p2.x
    
    def points_up(self) -> bool:
        return self.p1.y > self.p2.y
    def points_down(self) -> bool:
        return self.p1.y < self.p2.y
    def points_left(self) -> bool:
        return self.p1.x > self.p2.x
    def points_right(self) -> bool:
        return self.p1.x < self.p2.x

    def o_intersects(self, o: 'LineSegment') -> bool:

        if self.is_horizontal() and o.is_vertical():
            return min(self.p1.x, self.p2.x) <= o.p1.x <= max(self.p1.x, self.p2.x) and min(o.p1.y, o.p2.y) <= self.p1.y <= max(o.p1.y, o.p2.y)
        elif self.is_vertical() and o.is_horizontal():
            return min(self.p1.y, self.p2.y) <= o.p1.y <= max(self.p1.y, self.p2.y) and min(o.p1.x, o.p2.x) <= self.p1.x <= max(o.p1.x, o.p2.x)
        elif self.is_horizontal() and o.is_horizontal() and self.p1.y == o.p1.y:
            return min(self.p1.x, self.p2.x) <= max(o.p1.x, o.p2.x) and max(self.p1.x, self.p2.x) >= min(o.p1.x, o.p2.x)
        elif self.is_vertical() and o.is_vertical() and self.p1.x == o.p1.x:
            return min(self.p1.y, self.p2.y) <= max(o.p1.y, o.p2.y) and max(self.p1.y, self.p2.y) >= min(o.p1.y, o.p2.y)

        
        return False

@dataclass
class Polygon:
    segments: list[LineSegment]

    def contains(self, o: 'Polygon') -> bool:
        for o_segment in o.segments:
            for s_segment in self.segments:
                if s_segment.o_intersects(o_segment):
                    return False
        return True
    
@dataclass
class Rectangle:
    p1: Point
    p2: Point

    def area(self) -> int:
        return (abs(self.p1.x - self.p2.x) + 1) * (abs(self.p1.y - self.p2.y) + 1)

    def to_polygon(self) -> Polygon:

        all_x = self.p1.x, self.p2.x
        all_y = self.p1.y, self.p2.y

        min_x, max_x = min(all_x), max(all_x)
        min_y, max_y = min(all_y), max(all_y)

        return Polygon(
            segments=[LineSegment(Point(p1x, p1y), Point(p2x, p2y))
                      for p1x, p1y, p2x, p2y in (
                          (min_x, min_y, max_x, min_y),
                          (max_x, min_y, max_x, max_y),
                          (max_x, max_y, min_x, max_y),
                          (min_x, max_y, min_x, min_y)
                      )
                      ]
        )


def parse_input(input: str):
    for line in input.splitlines():
        x, y = tuple(map(int, line.split(',')))
        yield Point(x=x, y=y)

def create_polygon_border(original_points: list[Point]) -> list[Point]:
    original_points = [original_points[-1], *original_points, original_points[0]]

    new_points: list[Point] = []
    for i in range(1, len(original_points)-1):
        pp = original_points[i-1]
        cp = original_points[i]
        np = original_points[i+1]

        # cn
        # p.
        if pp.y > cp.y and pp.x == cp.x and np.x > cp.x and np.y == cp.y:
            bp = Point(x=cp.x-1, y=cp.y-1)
        # pc
        # .n
        elif pp.x < cp.x and pp.y == cp.y and np.y > cp.y and np.x == cp.x:
            bp = Point(x=cp.x+1, y=cp.y-1)
        # .p
        # nc
        elif pp.y < cp.y and pp.x == cp.x and np.x < cp.x and np.y == cp.y:
            bp = Point(x=cp.x+1, y=cp.y+1)
        # n.
        # cp
        elif pp.x > cp.x and pp.y == cp.y and np.y < cp.y and np.x == cp.x:
            bp = Point(x=cp.x-1, y=cp.y+1)
        # cp
        # n.
        elif pp.x > cp.x and pp.y == cp.y and np.y > cp.y and np.x == cp.x:
            bp = Point(x=cp.x+1, y=cp.y+1)
        # nc
        # .p
        elif pp.y > cp.y and pp.x == cp.x and np.x < cp.x and np.y == cp.y:
            bp = Point(x=cp.x-1, y=cp.y+1)
        # .n
        # pc
        elif pp.x < cp.x and pp.y == cp.y and np.y < cp.y and np.x == cp.x:
            bp = Point(x=cp.x-1, y=cp.y-1)
        # p.
        # cn
        elif pp.y < cp.y and pp.x == cp.x and np.x > cp.x and np.y == cp.y:
            bp = Point(x=cp.x+1, y=cp.y-1)
        else:
            assert False, "Error in corner conditions"

        new_points.append(bp)
    return new_points
        

def main():

    with open('input_day9.txt') as f:
        input = f.read()

    input_points = list(parse_input(input))

    potential_rectangle_corners = list(sorted((Rectangle(p1=p1, p2=p2) for p1_idx, p1 in enumerate(input_points) for p2 in input_points[p1_idx+1:]), key=lambda rect: rect.area(), reverse=True))

    given_polygon = Polygon(segments=[LineSegment(p1, p2) for p1, p2 in zip(input_points, [*input_points[1:], input_points[0]])])
    border_polygon_points = create_polygon_border(original_points=input_points)
    border_polygon = Polygon(segments=[LineSegment(p1, p2) for p1, p2 in zip(border_polygon_points, [*border_polygon_points[1:], border_polygon_points[0]])])

    for segment in given_polygon.segments:
        assert segment.p1.x == segment.p2.x or segment.p1.y == segment.p2.y
    for segment in border_polygon.segments:
        assert segment.p1.x == segment.p2.x or segment.p1.y == segment.p2.y


    for potential_rectangle in tqdm.tqdm(potential_rectangle_corners):
        if border_polygon.contains(potential_rectangle.to_polygon()):

            border_polygon.contains(potential_rectangle.to_polygon())

            # plt.figure()
            # plt.fill([ls.p1.x for ls in border_polygon.segments], [ls.p1.y for ls in border_polygon.segments], color=('blue', .3) )

            # # plt.fill([ls.p1.x for ls in given_polygon.segments], [ls.p1.y for ls in given_polygon.segments], color=('green', .3))

            # plt.fill([ls.p1.x for ls in potential_rectangle.to_polygon().segments], [ls.p1.y for ls in potential_rectangle.to_polygon().segments], color=('red', .3))
            # plt.axis('equal')
            # plt.show()

            return potential_rectangle.area()

if __name__ == "__main__":
    print(f'Answer: {main()}')
