// Starknet imports

use starknet::ContractAddress;

// Dojo imports

use dojo::world::IWorldDispatcher;

// Interfaces

#[starknet::interface]
trait IActions<TContractState> {
    fn create(self: @TContractState, name: felt252) -> u32;
    fn join(self: @TContractState, game_id: u32, name: felt252);
    fn move(ref self: TContractState, game_id: u32, piece_id: u8, to: u8);
}

// Contracts

#[dojo::contract]
mod actions {
    // Component imports

    use chess::components::playable::PlayableComponent;

    // Local imports

    use super::IActions;

    // Components

    component!(path: PlayableComponent, storage: playable, event: PlayableEvent);
    impl PlayableInternalImpl = PlayableComponent::InternalImpl<ContractState>;

    // Storage

    #[storage]
    struct Storage {
        #[substorage(v0)]
        playable: PlayableComponent::Storage,
    }

    // Events

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        PlayableEvent: PlayableComponent::Event,
    }

    // Implementations

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn create(self: @ContractState, name: felt252) -> u32 {
            self.playable.create(self.world(), name)
        }

        fn join(self: @ContractState, game_id: u32, name: felt252) {
            self.playable.join(self.world(), game_id, name)
        }

        fn move(ref self: ContractState, game_id: u32, piece_id: u8, to: u8) {
            self.playable.move(self.world(), game_id, piece_id, to)
        }
    }
}
