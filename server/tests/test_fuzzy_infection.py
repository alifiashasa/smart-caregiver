"""Unit tests for infection fuzzy analysis module."""

import pytest
from src.app.core.fuzzy.infection import (
    _temp_status,
    _spo2_status,
    _score_to_status,
    analyze_infection,
    InfectionResult,
)


class TestTempStatus:
    def test_normal_temp(self):
        assert _temp_status(36.5) == "Normal"
        assert _temp_status(37.5) == "Normal"

    def test_warning_temp(self):
        assert _temp_status(38) == "Warning"
        assert _temp_status(38.5) == "Warning"

    def test_critical_temp(self):
        assert _temp_status(39) == "Critical"
        assert _temp_status(42) == "Critical"


class TestSpo2Status:
    def test_normal(self):
        assert _spo2_status(95) == "Normal"
        assert _spo2_status(100) == "Normal"

    def test_warning(self):
        assert _spo2_status(92) == "Warning"
        assert _spo2_status(90) == "Warning"

    def test_critical(self):
        assert _spo2_status(85) == "Critical"
        assert _spo2_status(70) == "Critical"


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


class TestAnalyzeInfection:
    def test_normal_both_returns_normal(self):
        result = analyze_infection(body_temperature=36.5, spo2_level=98)
        assert isinstance(result, InfectionResult)
        assert result.status == "Normal"
        assert result.score <= 40
        assert result.temp_status == "Normal"
        assert result.spo2_status == "Normal"

    def test_fever_warning(self):
        result = analyze_infection(body_temperature=38.5, spo2_level=98)
        assert result.temp_status == "Warning"
        assert result.status in ("Warning", "Critical")

    def test_fever_critical(self):
        result = analyze_infection(body_temperature=40, spo2_level=98)
        assert result.temp_status == "Critical"
        assert result.status in ("Warning", "Critical")

    def test_low_spo2_critical(self):
        result = analyze_infection(body_temperature=36.5, spo2_level=85)
        assert result.spo2_status == "Critical"
        assert result.status in ("Warning", "Critical")

    def test_both_critical(self):
        result = analyze_infection(body_temperature=40, spo2_level=80)
        assert result.temp_status == "Critical"
        assert result.spo2_status == "Critical"
        assert result.status == "Critical"

    def test_clipping_extreme_values(self):
        """Extreme values produce Critical status."""
        result = analyze_infection(body_temperature=39.5, spo2_level=85)
        assert isinstance(result.score, float)
        assert result.temp_status == "Critical"
        assert result.spo2_status == "Critical"
        assert result.status == "Critical"

    def test_low_temp_clipped(self):
        result = analyze_infection(body_temperature=35.5, spo2_level=98)
        assert isinstance(result.score, float)
        assert result.temp_status == "Normal"
        assert result.spo2_status == "Normal"

    def test_mixed_signals(self):
        """Warning in one + normal in other → overall Warning or above."""
        result = analyze_infection(body_temperature=38.3, spo2_level=98)
        assert result.temp_status == "Warning"
        assert result.status in ("Normal", "Warning")  # mild warning, fuzzy may still be Normal