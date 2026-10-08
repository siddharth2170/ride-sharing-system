class StatisticsCalculator:
    """Calculate descriptive statistics for a nonempty integer list."""

    def __init__(self, values: list[int]) -> None:
        if not values:
            raise ValueError("at least one value is required")
        if any(type(value) is not int for value in values):
            raise TypeError("all values must be integers")
        self._values = values.copy()

    def mean(self) -> float:
        return sum(self._values) / len(self._values)

    def median(self) -> float:
        ordered = sorted(self._values)
        middle = len(ordered) // 2
        if len(ordered) % 2:
            return float(ordered[middle])
        return (ordered[middle - 1] + ordered[middle]) / 2

    def mode(self) -> list[int]:
        frequencies: dict[int, int] = {}
        for value in self._values:
            frequencies[value] = frequencies.get(value, 0) + 1
        highest = max(frequencies.values())
        return sorted(value for value, count in frequencies.items() if count == highest)

    def display(self) -> None:
        print("Data:", *self._values)
        print(f"Mean: {self.mean():.2f}")
        print(f"Median: {self.median():.2f}")
        print("Mode(s):", *self.mode())


if __name__ == "__main__":
    StatisticsCalculator([4, 1, 2, 2, 3, 4, 4, 5]).display()
