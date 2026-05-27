"""Unit tests for cardiovascular fuzzy analysis module."""

import pytest
from src.app.core.fuzzy.cardiovascular import (
    _bp_status,
    _hr_status,
    _spo2_status,
    _score_to_status,
    analyze_cardiovascular,
    CardioResult,
)


class TestBpStatus:
    def test_normal_bp(self):
        assert _bp_status(100) == "Normal"
        assert _bp_status(120) == "Normal"
        assert _bp_status(80) == "Normal"

    def test_warning_bp(self):
        assert _bp_status(130) == "Warning"
        assert _bp_status(140) == "Warning"

    def test_critical_bp(self):
        assert _bp_status(160) == "Critical"
        assert _bp_status(200) == "Critical"


class TestHrStatus:
    def test_normal_hr(self):
        assert _hr_status(60) == "Normal"
        assert _hr_status(100) == "Normal"

    def test_warning_hr(self):
        assert _hr_status(110) == "Warning"
        assert _hr_status(120) == "Warning"

    def test_critical_hr(self):
        assert _hr_status(130) == "Critical"
        assert _hr_status(150) == "Critical"


class TestSpo2Status:
    def test_normal_spo2(self):
        assert _spo2_status(100) == "Normal"
        assert _spo2_status(95) == "Normal"

    def test_warning_spo2(self):
        assert _spo2_status(93) == "Warning"
        assert _spo2_status(90) == "Warning"

    def test_critical_spo2(self):
        assert _spo2_status(85) == "Critical"
        assert _spo2_status(70) == "Critical"


class TestScoreToStatus:
    def test_normal_score(self):
        assert _score_to_status(0) == "Normal"
        assert _score_to_status(40) == "Normal"

    def test_warning_score(self):
        assert _score_to_status(41) == "Warning"
        assert _score_to_status(70) == "Warning"

    def test_critical_score(self):
        assert _score_to_status(71) == "Critical"
        assert _score_to_status(100) == "Critical"


class TestAnalyzeCardiovascular:
    def test_all_normal_returns_normal(self):
        result = analyze_cardiovascular(systolic_bp=110, heart_rate=80, spo2_level=98)
        assert isinstance(result, CardioResult)
        assert result.status == "Normal"
        assert result.score <= 40
        assert result.bp_status == "Normal"
        assert result.hr_status == "Normal"
        assert result.spo2_status == "Normal"

    def test_high_bp_returns_warning_or_critical(self):
        result = analyze_cardiovascular(systolic_bp=170, heart_rate=80, spo2_level=98)
        assert result.bp_status == "Critical"
        # Overall status may be Warning or Critical depending on fuzzy combination
        assert result.status in ("Warning", "Critical")

    def test_high_hr_returns_warning_or_critical(self):
        result = analyze_cardiovascular(systolic_bp=110, heart_rate=140, spo2_level=98)
        assert result.hr_status == "Critical"
        assert result.status in ("Warning", "Critical")

    def test_low_spo2_returns_critical(self):
        result = analyze_cardiovascular(systolic_bp=110, heart_rate=80, spo2_level=85)
        assert result.spo2_status == "Critical"
        assert result.status in ("Warning", "Critical")

    def test_extreme_values_clipped(self):
        """Extreme values produce Critical status."""
        result = analyze_cardiovascular(systolic_bp=160, heart_rate=130, spo2_level=85)
        assert isinstance(result.score, float)
        assert result.bp_status == "Critical"
        assert result.hr_status == "Critical"
        assert result.spo2_status == "Critical"
        assert result.status == "Critical"

    def test_normal_values_low_end(self):
        """Low normal values produce Normal status."""
        result = analyze_cardiovascular(systolic_bp=85, heart_rate=65, spo2_level=99)
        assert result.status == "Normal"
        assert result.bp_status == "Normal"
        assert result.hr_status == "Normal"
        assert result.spo2_status == "Normal"

    def test_mixed_signals(self):
        """Mixed warning/critical signals produce non-Normal status."""
        result = analyze_cardiovascular(systolic_bp=110, heart_rate=75, spo2_level=88)
        assert result.spo2_status == "Critical"  # spo2 is inverse
        # Even with normal bp/hr, low spo2 should push overall above Normal
        assert result.status != "Normal"

    def test_score_is_rounded(self):
        result = analyze_cardiovascular(systolic_bp=110, heart_rate=80, spo2_level=98)
        # score should be rounded to 2 decimal places
        score_str = str(result.score)
        dot_idx = score_str.find(".")
        if dot_idx >= 0:
            assert len(score_str) - dot_idx - 1 <= 2