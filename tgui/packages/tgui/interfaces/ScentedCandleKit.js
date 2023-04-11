import { useBackend } from '../backend';
import { Window } from '../layouts';

export const ScentedCandleKit = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window resizable theme="candlekit">
      <Window.Content>
        Hello world!
      </Window.Content>
    </Window>
  );
};
