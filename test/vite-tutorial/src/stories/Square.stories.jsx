import React, { useState } from 'react';
import { Square } from '../App';

export default {
    title: 'TicTacToe/Square',
    component: Square,
};

export const Empty = {
    args: {
        value: null,
        onSquareClick: () => { },
    },
};

export const X = {
    args: {
        value: 'X',
        onSquareClick: () => { },
    },
};

export const O = {
    args: {
        value: 'O',
        onSquareClick: () => { },
    },
};
