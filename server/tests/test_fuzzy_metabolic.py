"""Unit tests for metabolic fuzzy analysis module."""

import pytest
from src.app.core.fuzzy.metabolic import (
    _sugar_status,
    _chol_status,
    _uric_status,
    _weight_status,
    _score_to_status,
    analyze_metabolic,
    MetabolicResult,
)


class TestSugarStatus:
    def test_normal(self):
        assert _sugar_status(100) == "Normal"
        assert _sugar_status(140) == "Normal"

    def test_warning(self):
        assert _sugar_status(150) == "Warning"
        assert _sugar_status(200) == "Warning"

    def test_critical(self):
        assert _sugar_status(250) == "Critical"
        assert _sugar_status(400) == "Critical"


class TestCholStatus:
    def test_normal(self):
        assert _chol_status(150) == "Normal"
        assert _chol_status(200) == "Normal"

    def test_warning(self):
        assert _chol_status(220) == "Warning"
        assert _chol_status(240) == "Warning"

    def test_critical(self):
        assert _chol_status(280) == "Critical"
        assert _chol_status(400) == "Critical"


class TestUricStatus:
    def test_normal(self):
        assert _uric_status(4) == "Normal"
        assert _uric_status(7) == "Normal"

    def test_warning(self):
        assert _uric_status(8) == "Warning"
        assert _uric_status(9) == "Warning"

    def test_critical(self):
        assert _uric_status(11) == "Critical"
        assert _uric_status(15) == "Critical"


class TestWeightStatus:
    def test_normal(self):
        assert _weight_status(60) == "Normal"
        assert _weight_status(75) == "Normal"

    def test_warning(self):
        assert _weight_status(80) == "Warning"
        assert _weight_status(95) == "Warning"

    def test_critical(self):
        assert _weight_status(110) == "Critical"
        assert _weight_status(150) == "Critical"


class TestScoreToStatus:
    def test_normal(self):
        assert _score_to_status(0) == "Normal"
        assert _score_to_status(40) == "Normal"

    def test_warning(self):
        assert _score_to_status(50) == "Warning"
        assert _score_to_status(70) == "Warning"

    def test_critical(self):
        assert _score_to_status(80) == "Critical"
        assert _score_to_status(100) == "Critical"


class TestAnalyzeMetabolic:
    def test_all_normal_returns_normal(self):
        result = analyze_metabolic(
            blood_sugar=100, cholesterol=150, uric_acid=4, body_weight=60
        )
        assert isinstance(result, MetabolicResult)
        assert result.status == "Normal"
        assert result.score <= 40
        assert result.sugar_status == "Normal"
        assert result.chol_status == "Normal"
        assert result.uric_status == "Normal"
        assert result.weight_status == "Normal"

    def test_high_sugar_critical(self):
        result = analyze_metabolic(
            blood_sugar=350, cholesterol=150, uric_acid=4, body_weight=60
        )
        assert result.sugar_status == "Critical"
        assert result.status in ("Warning", "Critical")

    def test_missing_params_defaults(self):
        """Missing parameters should use normal defaults and not push score up."""
        result = analyze_metabolic(blood_sugar=300)
        assert result.sugar_status == "Critical"
        # Missing params should show as N/A
        assert result.chol_status == "N/A"
        assert result.uric_status == "N/A"
        assert result.weight_status == "N/A"

    def test_all_missing_one_provided(self):
        """With only one param provided, only that one affects the score."""
        result = analyze_metabolic(body_weight=130)
        assert result.weight_status == "Critical"
        assert result.chol_status == "N/A"
        assert result.sugar_status == "N/A"
        assert result.uric_status == "N/A"

    def test_high_cholesterol(self):
        result = analyze_metabolic(cholesterol=350)
        assert result.chol_status == "Critical"
        assert result.status in ("Warning", "Critical")

    def test_high_uric_acid(self):
        result = analyze_metabolic(uric_acid=14)
        assert result.uric_status == "Critical"
        assert result.status in ("Warning", "Critical")

    def test_mixed_normal_and_abnormal(self):
        """One abnormal parameter among normals should still elevate score."""
        result = analyze_metabolic(
            blood_sugar=100, cholesterol=350, uric_acid=4, body_weight=60
        )
        assert result.chol_status == "Critical"
        assert result.sugar_status == "Normal"
        assert result.status in ("Warning", "Critical")

    def test_all_params_empty(self):
        """All params None still produces a result with defaults."""
        result = analyze_metabolic()
        assert isinstance(result, MetabolicResult)
        assert result.status == "Normal"
        # All should be N/A
        assert result.sugar_status == "N/A"
        assert result.chol_status == "N/A"
        assert result.uric_status == "N/A"
        assert result.weight_status == "N/A"

    def test_clipping_extreme(self):
        """Extreme values at universe boundaries produce valid result."""
        result = analyze_metabolic(blood_sugar=350, cholesterol=300, uric_acid=12, body_weight=120)
        assert isinstance(result.score, float)
        assert result.sugar_status == "Critical"
        assert result.chol_status == "Critical"
        assert result.uric_status == "Critical"
        assert result.weight_status == "Critical"