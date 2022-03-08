import { useBackend, useLocalState } from "../backend";
import { Box, Button, Divider, Dropdown, Flex, Icon, LabeledList, Modal, NumberInput, Section, Tabs } from "../components";
import { Window } from "../layouts";

export const PreferencesWindow = (props, context) => {
  const { data } = useBackend(context);
  const [tab, setTab] = useLocalState(context, 'prefsPage', 0);
  const page = () => {
    switch (tab) {
      case 0: return <CharacterInfoPage />;
      case 1: return <AppearancePage />;
      case 2: return <LoadoutPage />;
      case 3: return <GamePrefsPage />;
      case 4: return <AntagsPage />;
      case 5: return <ContentPrefsPage />;
    }
  };

  return (
    <Window>
      <Window.Content>
        <PreferencesTabs tab={tab} setTab={setTab} />
        {page()}
      </Window.Content>
    </Window>
  );
};

const PreferencesTabs = (props, context) => { 
  const { tab, setTab } = props;

  return (
    <Tabs>
      <Tabs.Tab
        selected={tab===0}
        onClick={() => setTab(0)}>
        Character Info
      </Tabs.Tab>
      <Tabs.Tab
        selected={tab===1}
        onClick={() => setTab(1)}>
        Appearance
      </Tabs.Tab>
      <Tabs.Tab
        selected={tab===2}
        onClick={() => setTab(2)}>
        Loadout
      </Tabs.Tab>
      <Tabs.Tab
        selected={tab===3}
        onClick={() => setTab(3)}>
        Game Preferences
      </Tabs.Tab>
      <Tabs.Tab
        selected={tab===4}
        onClick={() => setTab(4)}>
        Antagonist Preferences
      </Tabs.Tab>
      <Tabs.Tab
        selected={tab===5}
        onClick={() => setTab(5)}>
        Content Preferences
      </Tabs.Tab>
    </Tabs>
  );
};

const CharacterInfoPage = (props, context) => {
  const [nameModalOpen, setNameModalOpen] = useLocalState(context, 'nameModalOpen', false);

  return (
    <>
      <Section title="Character Info">
        <LabeledList>
          <LabeledList.Item label="Name">
            <Button.Input content="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" maxLength={42} /> 
            <Button icon="dice-five" tooltip="Always Randomize Name" color="grey" />
            <Button icon="user-slash" tooltip="Toggle Nameless" color="grey" />
            <Button icon="ellipsis-h" tooltip="Alternate Names" onClick={() => setNameModalOpen(true)} />
          </LabeledList.Item>
          <LabeledList.Item label="Age">
            <NumberInput value={45} minValue={21} maxValue={85} unit="years" />
          </LabeledList.Item>
          <LabeledList.Item label="Body Style">
            <Dropdown options={['male', 'female']} selected="masculine" />
          </LabeledList.Item>
          <LabeledList.Item label="Pronouns">
            <Dropdown 
              width="15em"
              options={['(same as body style)', 'male', 'female', 'nonbinary', 'object']} 
              selected="(same as body style)" />
          </LabeledList.Item>
          <LabeledList.Item label="Species">
            <Dropdown options={['human']} selected={'human'} />
          </LabeledList.Item>
          <LabeledList.Item label="Custom species">
            <Button.Input content="(no custom name)" />  
          </LabeledList.Item>
        </LabeledList>
      </Section>
    
      {nameModalOpen && <AltNamesModal />}
    </>
  );
};

const AltNamesModal = (props, context) => {
  const [nameModalOpen, setNameModalOpen] = useLocalState(context, 'nameModalOpen', false);

  return (
    <Modal width={30}>
      <Box>
        <Section title={(
          <Flex justify="space-between">
            <Flex.Item>Alternate Names</Flex.Item>
            <Flex.Item><Button onClick={() => setNameModalOpen(false)} icon="times" color="red" /></Flex.Item>
          </Flex>
        )}>
          Hello World!
        </Section>
      </Box>
    </Modal>
  );
};

const AppearancePage = (props, context) => {
  return (
    <Section title="Character Appearance">
      Hello World! 2 Quo debitis distinctio sint commodi, excepturi, doloremque
      voluptatibus laborum reprehenderit, ut praesentium deleniti molestiae sed
      repudiandae vero totam minima doloribus eius? Pariatur quisquam voluptatum
      omnis explicabo voluptate, commodi harum eius.
    </Section>
  );
};

const LoadoutPage = (props, context) => {
  return (
    <Section title="Character Loadout">
      Hello World! 3 Porro quo molestiae itaque facere omnis, vero error voluptas
      eum voluptate iure illo officia? Repellendus nam facere aliquid cumque
      architecto ea, libero odio tenetur non ipsam, omnis nulla quisquam? Eos.
    </Section>
  );
};

const GamePrefsPage = (props, context) => {
  return (
    <Section title="Game Preferences">
      Hello World! 4 Nisi asperiores, sint consequuntur. Recusandae corporis
      mollitia, sequi debitis quo neque accusamus, nesciunt nulla pariatur
      ad itaque rem cum. Velit veritatis exercitationem deleniti saepe illo
      consequuntur. Maxime veniam sapiente autem?
    </Section>
  );
};

const AntagsPage = (props, context) => {
  return (
    <Section title="Antagonist Preferences">
      Hello World! 5 Eum aperiam atque placeat iste error, nulla provident.
      Provident nobis consectetur esse, reprehenderit nam temporibus ipsa,
      sunt quae dicta consequatur sapiente, rem. Accusamus nihil, assumenda
      dolorum, minus ratione doloremque repudiandae.
    </Section>
  );
};

const ContentPrefsPage = (props, context) => {
  return (
    <Section title="Content Preferences">
      Hello World! 6 Ea atque harum odit, aut, fugiat iste facilis illo
      at rerum sint quos perspiciatis adipisci laboriosam! Explicabo
      nostrum, quas, ut molestias earum velit rem nemo. Rem, officiis,
      repellendus. Eveniet, eos.
    </Section>
  );
};