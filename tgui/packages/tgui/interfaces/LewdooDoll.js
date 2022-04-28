import { useBackend, useLocalState } from '../backend';
import { Box, Button, Divider, Dropdown, Flex, Section, Tabs } from '../components';
import { FlexItem } from '../components/Flex';
import { Window } from '../layouts';

export const LewdooDoll = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Window resizable>
      <Window.Content scrollable className={"LewdooDoll__WindowContent"}>
        <Flex className={"LewdooDoll__Flex"}>
          <FlexItem grow={1} className={"LewdooDoll__Interaction"}>
            <DollInteraction />
          </FlexItem>
          <FlexItem style={{ "maxWidth": "40%" }}>
            <DollCustomization />
          </FlexItem>
        </Flex>
      </Window.Content>
    </Window>
  );
};

const DollInteraction = (props, context) => {
  const { act, data } = useBackend(context);
  const { possibleTargets, target, intent, interactions, zone } = data;
  const [tab, setTab] = useLocalState(context, "actionTab", 0);

  const getActionsFromTab = () => {
    const _parts = interactions[intent];
    const _keys = Object.keys(_parts);
    if (tab>_keys.length) {
      setTab(0);
    }
    const _realKey = _keys[tab];
    const _actions = _parts[_realKey];
    return _actions;
  };

  return (
    <>
      <Section title="Target" className={"LewdooDoll__Section"}>
        <Flex>
          <Flex.Item grow={1}>
            <Dropdown 
              options={["(none)", ...possibleTargets]} 
              selected={possibleTargets.includes(target) ? target : null || "(none)"}
              width="160px"
              onSelected={selected => act("prompt_target", { target: selected })} />
            <Button 
              icon="eject"
              content="Eject item"
              width="160px"
              onClick={() => act("eject_item")} />
          </Flex.Item>
          <Flex.Item grow={1} style={{ textAlign: "right" }}>
            {target 
              ? (<Box color="green">Target linked</Box>) 
              : <Box color="red">No target found</Box> }
          </Flex.Item>
        </Flex>
      </Section>
      <Section title="Interact">
        <Box>
          <Button
            content="HELP"
            color={intent === "help" ? "green" : null}
            onClick={() => act("switch_intent", { intent: "help" })} />
          <Button
            content="GRAB"
            color={intent === "grab" ? "yellow" : null}
            onClick={() => act("switch_intent", { intent: "grab" })} />
          <Button
            content="DISARM"
            color={intent === "disarm" ? "blue" : null}
            onClick={() => act("switch_intent", { intent: "disarm" })} />
          <Button
            content="HARM"
            color={intent === "harm" ? "red" : null}
            onClick={() => act("switch_intent", { intent: "harm" })} />
        </Box>
        <Divider />
        <Section>
          <Flex>
            <FlexItem>
              <Tabs vertical>
                {Object.keys(interactions[intent]).map((part, i) => (
                  <Tabs.Tab 
                    key={part}
                    selected={part === zone}
                    onClick={() => {
                      setTab(i);
                      if (part !== "default") {
                        act("switch_zone", part);
                      }
                    }}>
                    {part}
                  </Tabs.Tab>
                ))}
              </Tabs>
            </FlexItem>
            <FlexItem grow={1}>
              {Object.entries(getActionsFromTab()).map(entry => {
                const [key, value] = entry;
                return (
                  <Box key={key}>
                    <Button
                      content={key}
                      onClick={() => act("interact", { action: value })}
                    />
                  </Box>
                );
              })}
            </FlexItem>
          </Flex>
        </Section>
      </Section>
    </>
  );
};

const DollCustomization = (props, context) => {
  const { act, data } = useBackend(context);
  const { colors, target, dollStyles, activeStyle } = data;

  return (
    <Section className={"LewdooDoll__Section"}>
      <Box>
        <Dropdown 
          options={dollStyles}
          selected={activeStyle}
          onSelected={selected => act("change_style", { style: selected })} />
      </Box>
      <Divider />
      {Object.keys(colors).map(colorName => (
        <Box key={colorName}>
          {colorName} <Button
            className="LewdooDoll__ColorButton"
            content={colors[colorName]}
            onClick={() => act("change_color", { color: colorName })}
            style={{
              border: "3px solid " + colors[colorName],
            }} />
        </Box>
      ))}
      <Divider />
      <Box>
        <Button
          content="Sync colors to target"
          disabled={!target}
          onClick={() => act("sync_colors_to_target")} />
      </Box>
    </Section>
  );
};