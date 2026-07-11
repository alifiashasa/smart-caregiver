"""remove_face_embedding_from_users

Revision ID: 006_remove_face_embedding
Revises: 3ff7cc37ac3c
Create Date: 2026-07-11 14:00:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '006_remove_face_embedding'
down_revision: Union[str, None] = '3ff7cc37ac3c'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.drop_column('users', 'face_embedding')


def downgrade() -> None:
    op.add_column('users', sa.Column('face_embedding', sa.LargeBinary(), nullable=True))
