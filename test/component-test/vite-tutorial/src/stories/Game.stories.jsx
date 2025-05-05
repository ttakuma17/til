import Game from '../App';
import { within, userEvent } from '@storybook/testing-library';
import { expect } from '@storybook/jest';

export default {
    title: 'TicTacToe/Game',
    component: Game,
};

export const Default = {};

export const XWins = {
    play: async ({ canvasElement }) => {
        const canvas = within(canvasElement);

        const squares = await canvas.findAllByRole('button', { name: '' });

        await userEvent.click(squares[0]); // X
        await userEvent.click(squares[3]); // O
        await userEvent.click(squares[1]); // X
        await userEvent.click(squares[4]); // O
        await userEvent.click(squares[2]); // X

        await expect(canvas.getByText(/Winner: X/)).toBeInTheDocument();
    },
};