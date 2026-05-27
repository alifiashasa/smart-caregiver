"""Unit tests for fuzzy engine orchestration."""

import pytest
from src.app.core.fuzzy.engine import (
    run_fuzzy_analysis,
    _status_from_score,
    FuzzyAnalysisResult,
)


class TestStatusFromScore:
    def test_normal(self):
        assert _status_from_score(0) == "Normal"
        assert _status_from_score(40) == "Normal"

    def test_warning(self):
        assert _status_from_score(50) == "Warning"
        assert _status_from_score(70) == "Warning"

    def test_critical(self):
        assert _status_from_score(80) == "Critical"
        assert _status_from_score(100) == "Critical"


class TestRunFuzzyAnalysis:
    def test_no_params_returns_empty(self):
        result = run_fuzzy_analysis()
        assert isinstance(result, FuzzyAnalysisResult)
        assert result.cardio is None
        assert result.metabolic is None
        assert result.infection is None
        assert result.final_score == 0.0
        assert result.final_status == "Normal"

    def test_cardio_only(self):
        """Only cardiovascular module should activate."""
        result = run_fuzzy_analysis(
            systolic_bp=110, heart_rate=80, spo2_level=98
        )
        assert result.cardio is not None
        assert result.metabolic is None
        assert result.infection is None
        assert result.final_score > 0
        assert result.final_status == "Normal"

    def test_cardio_needs_all_params(self):
        """Cardiovascular requires all three params."""
        result = run_fuzzy_analysis(systolic_bp=110, heart_rate=80)  # missing spo2
        assert result.cardio is None
        assert result.metabolic is None
        assert result.infection is None

    def test_metabolic_single_param_triggers(self):
        """Metabolic activates with ANY single param."""
        result = run_fuzzy_analysis(blood_sugar=100)
        assert result.cardio is None
        assert result.metabolic is not None
        assert result.infection is None

    def test_infection_needs_both(self):
        """Infection requires both temp and spo2."""
        result = run_fuzzy_analysis(body_temperature=36.5)  # missing spo2
        assert result.infection is None
        assert result.cardio is None
        assert result.metabolic is None

    def test_infection_activates_with_both(self):
        result = run_fuzzy_analysis(body_temperature=36.5, spo2_level=98)
        assert result.infection is not None

    def test_all_three_modules(self):
        result = run_fuzzy_analysis(
            systolic_bp=110, heart_rate=80, spo2_level=98,
            blood_sugar=100, cholesterol=150, uric_acid=4, body_weight=60,
            body_temperature=36.5,
        )
        # All modules share spo2_level, cardio needs spo2, infection needs spo2+temp
        assert result.cardio is not None
        assert result.metabolic is not None
        assert result.infection is not None
        assert result.final_score > 0
        assert result.final_status == "Normal"

    def test_aggregation_averages(self):
        """Final score should be average of active module scores."""
        result = run_fuzzy_analysis(
            systolic_bp=110, heart_rate=80, spo2_level=98,
            blood_sugar=100,
        )
        assert result.cardio is not None
        assert result.metabolic is not None
        # final_score should be avg of cardio and metabolic scores
        expected_avg = round((result.cardio.score + result.metabolic.score) / 2, 2)
        assert result.final_score == expected_avg

    def test_high_values_produce_critical(self):
        result = run_fuzzy_analysis(
            systolic_bp=190, heart_rate=140, spo2_level=75,
            blood_sugar=350, body_temperature=40,  # infection won't activate without spo2
        )
        assert result.final_status == "Critical"
        assert result.cardio is not None
        assert result.metabolic is not None

    def test_spo2_shared_between_cardio_and_infection(self):
        """Spo2 is shared between cardio and infection modules."""
        result = run_fuzzy_analysis(
            systolic_bp=110, heart_rate=80, spo2_level=85,
            body_temperature=36.5,
        )
        assert result.cardio is not None
        assert result.infection is not None
        assert result.cardio.spo2_status == "Critical"
        assert result.infection.spo2_status == "Critical"

    def test_detail_dict_format(self):
        result = run_fuzzy_analysis(
            systolic_bp=110, heart_rate=80, spo2_level=98,
            blood_sugar=100, body_temperature=36.5,
        )
        detail = result.to_detail_dict()
        assert "final_score" in detail
        assert "final_status" in detail
        assert "cardiovascular" in detail
        assert "metabolic" in detail
        assert "infection" in detail
        # Check parameter structure
        cardio = detail["cardiovascular"]
        assert "score" in cardio
        assert "status" in cardio
        assert "parameters" in cardio
        assert "blood_pressure" in cardio["parameters"]
        assert "heart_rate" in cardio["parameters"]
        assert "spo2" in cardio["parameters"]

    def test_to_detail_dict_missing_modules(self):
        """Detail dict should only include active modules."""
        result = run_fuzzy_analysis(blood_sugar=100)
        detail = result.to_detail_dict()
        assert "cardiovascular" not in detail
        assert "metabolic" in detail
        assert "infection" not in detail