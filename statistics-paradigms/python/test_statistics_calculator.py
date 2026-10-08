import unittest

from statistics_calculator import StatisticsCalculator


class StatisticsCalculatorTests(unittest.TestCase):
    def test_sample_data(self) -> None:
        calculator = StatisticsCalculator([4, 1, 2, 2, 3, 4, 4, 5])
        self.assertEqual(calculator.mean(), 3.125)
        self.assertEqual(calculator.median(), 3.5)
        self.assertEqual(calculator.mode(), [4])

    def test_even_and_multimodal_data(self) -> None:
        calculator = StatisticsCalculator([1, 1, 2, 2])
        self.assertEqual(calculator.median(), 1.5)
        self.assertEqual(calculator.mode(), [1, 2])

    def test_empty_data_is_rejected(self) -> None:
        with self.assertRaises(ValueError):
            StatisticsCalculator([])


if __name__ == "__main__":
    unittest.main()
