import { Board } from '../App';

export default {
    title: 'TicTacToe/Board',
    component: Board,
};

export const Empty = {
    args: {
        xIsNext: true,
        squares: Array(9).fill(null),
        onPlay: () => { },
    },
};

export const InProgress = {
    args: {
        xIsNext: false,
        squares: ['X', 'O', 'X', null, null, null, null, null, null],
        onPlay: () => { },
    },
};


export const XWins = {
    args: {
        xIsNext: false,
        squares: ['X', 'X', 'X', 'O', 'O', null, null, null, null],
        onPlay: () => { },
    },
};

export const OWins = {
    args: {
        xIsNext: false,
        squares: ['X', 'X', null, null, 'X', null, 'O', 'O', 'O'],
        onPlay: () => { },
    },
};

export const FillInTriangle = {
    args: {
        xIsNext: false,
        squares: ['△', '△', '△', '△', '△', '△', '△', '△', '△'],
        onPlay: () => { },
    },
}